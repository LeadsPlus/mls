class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :county
  after_initialize :init

  def init
    self.min_payment ||= 800
    self.max_payment ||= 1_000
    self.deposit ||= 50_000
    self.term ||= 25
    self.county ||= "Fermanagh"
  end

#  Do I need BigDecimals here?
#  Cycle through every rate in the tabe and construct a hash with one entry for each LTV bracket
#  The value of the entry will be the lowest rate available in that LTV level
  def rates
#    format: minimum deposit % needed to get this rate => rate
    rates = {}
    Rate.find_each do |rate|
#      keep in mind this is overwriting
      if rates.has_key?(100-rate.max_ltv)
        rates[100-rate.max_ltv] = rate.initial_rate if rate.initial_rate < rates[100-rate.max_ltv]
      else
        rates[100-rate.max_ltv] = rate.initial_rate
      end
    end
    rates
  end

  def eventual_rate
    rates[affordable_prices.max[0]]
  end

#  Convert a given rate to it's effective counterpart
  def effective_rate(rate)
#    this is going to fuck me up majorly if I move to BigDecimal
    rate.to_f/1200
  end

#  hash of form min_depos => eff_rate
#  cycle through the rates hash, converting each value to it's effective counterpart
  def effective_rates
    rates.merge(rates){|min_depos, rate| effective_rate rate }
  end

#  calculate the principal given an effective rate and monthly payment ammount
  def princ(eff_rate, payment)
    (payment/eff_rate)*(1-(1+eff_rate)**-(term*12))
  end

#  cycle through the effective rates hash, calculating the most expensive house we can afford
#  assuming we are able to buy at each particular rate, given the deposit we have to offer
  def max_prices_given_rate
    effective_rates.merge(effective_rates){|min_depos, eff_rate| princ(eff_rate, max_payment)+deposit}
  end

#  I'm not too sure that this is the right solution for min price.
#  Need to study the excel sheet more to try work it out.
  def min_price
    princ(effective_rates.values.max, min_payment)+deposit
  end

#  cycle through the max_prices hash, rejecting prices that we can't actually afford
#  given the deposit we have to offer
#  The 'answer' will be the highest price we can afford, given our deposit
#    .max will give back [depos_percent, max_price]
#    .values.max will just give max_price
  def affordable_prices
    max_prices_given_rate.reject { |min_depos, price| min_depos > deposit*100/price }
  end

  def pmt_at(price)
    effective_rate(eventual_rate) / ((1+effective_rate(eventual_rate))**(term*12)-1) *
        -((price-deposit)*((1+effective_rate(eventual_rate))**(term*12)))
  end

  def matches
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => min_price, :max => affordable_prices.values.max, :county => county })
  end



  validates :max_payment, :presence => true,
                          :numericality => { :greater_than => 0 }

  validates :min_payment, :presence => true,
                          :numericality => { :greater_than => 0 }

  validates :deposit, :presence => true,
                      :numericality => { :greater_than => 0 }

  validates :term, :presence => true,
                   :numericality => { :greater_than => 0, :less_than_or_equal_to => 60 }

  validates :county, :presence => true
end







# == Schema Information
#
# Table name: searches
#
#  id          :integer         not null, primary key
#  max_payment :integer
#  deposit     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  min_payment :integer
#  term        :integer
#  county      :string(255)
#

