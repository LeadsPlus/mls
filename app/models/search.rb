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

#  Cycle through every rate in the table and construct a hash with one entry for each LTV bracket
#  The value of the entry will be the lowest rate available in that LTV level
  def rates
#    format: minimum deposit % needed to get this rate => BigDecimal(rate)
    rates = {}
    Rate.find_each do |rate|
      if rates.has_key?(100-rate.max_ltv)
        rates[100-rate.max_ltv] = rate.avg_rate(term) if rate.avg_rate(term) < rates[100-rate.max_ltv]
      else
        rates[100-rate.max_ltv] = rate.avg_rate(term)
      end
    end
    rates
  end

  def eventual_rate
#    I think that this is trying to access a key that doesn't exist in some circumstances
    Rails.logger.debug "Depos Bracket: #{affordable_prices[0]}"
    rates[affordable_prices[0]]
  end

#  Convert a given rate to it's effective counterpart
  def effective_rate(rate)
    BigDecimal.new(rate.to_s, 2)/1200
  end

#  hash of form min_depos_needed_to_avail => eff_rate
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
    princ(effective_rate(eventual_rate), min_payment)+deposit
  end

#  cycle through the max_prices hash, rejecting prices that we can't actually afford
#  given the deposit we have to offer
#  The 'answer' will be the highest price we can afford, given our deposit
#    .max will give back [depos_percent, max_price]
#    .values.max will just give max_price
  def affordable_prices
    affords = max_prices_given_rate.reject { |min_depos, price| min_depos > deposit*100/price }
#    now I need to reject all but the one which affords us the largest principal
    affords.select {|k,v| v == affords.values.max }.max
  end

  def max_total_paid
    max_payment*12*term
  end

  def min_total_paid
    min_payment*12*term
  end

  def pmt_at(price)
    effective_rate(eventual_rate) / ((1+effective_rate(eventual_rate))**(term*12)-1) *
        -((price-deposit)*((1+effective_rate(eventual_rate))**(term*12)))
  end

  def matches
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => min_price, :max => affordable_prices[1], :county => county })
  end

  def max_payment_less_than_min_payment
    errors.add(:max_payment, "cannot be less than the Min. payment") if max_payment < min_payment
  end

  def has_some_affordable_prices
    affords = max_prices_given_rate.reject { |min_depos, price| min_depos > deposit*100/price }
    errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range" if affords.length.zero?
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
  validate :max_payment_less_than_min_payment
#  I have this implemented wrong. I'm calculating affordable prices twice every search
  validate :has_some_affordable_prices
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

