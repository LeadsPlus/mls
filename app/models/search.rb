class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :county, :loan_type, :initial_period_length, :lender
  attr_reader :viable_rates, :rates, :effective_rates,
              :max_prices_given_rate, :best_price, :eventual_rate,
              :min_price, :matches
  after_initialize :init

  before_validation { Rails.logger.debug "Validation begins here" }
  after_validation do
    Rails.logger.debug "Validation Ends here"
#    do_everything
  end

  def init
    self.min_payment ||= 800
    self.max_payment ||= 1_000
    self.deposit ||= 50_000
    self.term ||= 25
    self.county ||= "Fermanagh"
    self.initial_period_length ||= nil
    self.loan_type ||= 'Any'
    self.lender ||= 'Any'
  end

  def calc_everything
    set_viable_rates # now we should have access to @viable_rates
    calc_rates_hash # now we should have access to @rates
    calc_effective_rates # @effective_rates
    calc_max_prices_given_rate # @max_prices_given_rate
    calc_affordable_prices # @affordable_prices
    calc_best_price # @best_price
    calc_eventual_rate # @eventual_rate
    calc_min_price # @min_price
  end

#  this might be a bad idea if I'm breaking the lazy loading ability?
#  I think I'm ok since this returns a ActiveRecord::Relation object
  def set_viable_rates
    @viable_rates = Rate.scope_by_lender(lender)
                      .scope_by_loan_type(loan_type)
                      .scope_by_initial_period(initial_period_length)
    Rails.logger.debug "Viable rates set: #{@viable_rates.inspect}"
  end

#  Cycle through every rate in the table and construct a hash with one entry for each LTV bracket
#  The value of the entry will be the lowest rate available in that LTV level
  def calc_rates_hash
    Rails.logger.debug "In the rates function"
#    format: minimum deposit % needed to get this rate => BigDecimal(rate)
    @rates = {}
    @viable_rates.each do |rate|
      if @rates.has_key?(100-rate.max_ltv)
        @rates[100-rate.max_ltv] = rate.avg_rate(term) if rate.avg_rate(term) < rates[100-rate.max_ltv]
      else
        @rates[100-rate.max_ltv] = rate.avg_rate(term)
      end
    end
    logger.debug "Rates Hash Calculated:"
    @rates.each {|d,r| logger.debug "Deposit: #{d}, Rate: #{r.truncate(4)}"}
#    rescue ActiveRecord::RecordNotFound
  end

  def has_mortgage_conditions?
    logger.debug "Checking if has mortgage conditions"
    loan_type != 'Any' || initial_period_length != nil || lender != "Any"
  end

#  Convert a given rate to it's effective counterpart
  def calc_effective_rate(rate)
    BigDecimal.new(rate.to_s, 2)/1200
  end

#  hash of form min_depos_needed_to_avail => eff_rate
#  cycle through the rates hash, converting each value to it's effective counterpart
  def calc_effective_rates
    @effective_rates = @rates.merge(@rates){|min_depos, rate| calc_effective_rate rate }
    Rails.logger.debug "Effective rates calculated:"
    @effective_rates.each {|d,r| logger.debug "Deposit: #{d}, Effective Rate: #{r.truncate(4)}"}
  end

#  calculate the principal given an effective rate and monthly payment ammount
  def calc_princ(eff_rate, payment)
    (payment/eff_rate)*(1-(1+eff_rate)**-(term*12))
  end

#  cycle through the effective rates hash, calculating the most expensive house we can afford
#  assuming we are able to buy at each particular rate, given the deposit we have to offer
  def calc_max_prices_given_rate
    @max_prices_given_rate = @effective_rates.merge(@effective_rates){|min_depos, eff_rate|
      calc_princ(eff_rate, max_payment)+deposit
    }
    Rails.logger.debug "Max prices calculated for each rate:"
    @max_prices_given_rate.each {|d,p| logger.debug "Deposit: #{d}, Max. Price: #{p.truncate(4)}"}
  end

#  cycle through the max_prices hash, rejecting prices that we can't actually afford
#  given the deposit we have to offer. Then select the setup which allows us the largest principal.
#    .max will give back [depos_percent, max_price]
#    .values.max will just give max_price
  def calc_affordable_prices
    @affordable_prices = @max_prices_given_rate.reject { |min_depos, price| min_depos > deposit*100/price }
    logger.debug "Affordable Prices determined "
    if @affordable_prices.length > 0
      @affordable_prices.each do |d, p|
        logger.debug "Deposit of: #{d} gives Price: #{p.truncate(4)}"
      end
    else
      logger.debug "There are no affordable prices"
    end
  end

  def calc_best_price
#    now I need to reject all but the one which affords us the largest principal
    @best_price = @affordable_prices.select! {|k,v| v == @affordable_prices.values.max }.max.to_a
    logger.debug "Determined the best price. Deposit of: #{@best_price[0]} gives Price: #{@best_price[1].truncate(3)}"
  end

  def calc_eventual_rate
    @eventual_rate = @rates[@best_price[0]]
    logger.debug "calculated the eventual rate as #{@eventual_rate} using deposit #{@best_price[0]}"
  end

  def calc_min_price
    @min_price = calc_princ(calc_effective_rate(@eventual_rate), min_payment)+deposit
    logger.debug "Calculated the min price as #{@min_price.truncate(3)}"
  end

  def pmt_at(price)
    logger.debug "Getting a PMT for a house"
    calc_effective_rate(@eventual_rate) / ((1+calc_effective_rate(@eventual_rate))**(term*12)-1) *
        -((price-deposit)*((1+calc_effective_rate(@eventual_rate))**(term*12)))
  end

  def matches
    calc_everything
    logger.debug "Details used for finding matches: \n Min. Price: #{@min_price.truncate(0)} \n"
    logger.debug "Max. Price: #{@best_price[1].truncate(0)} \n County: #{county}"
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => @min_price.truncate(0), :max => @best_price[1].truncate(0), :county => county })
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
#  these validations happen in the order they're listed here
#  @viable rates is built in 'has_some_viable_rates' and can then be used in 'has_some_affordable_prices'
  validate :max_payment_less_than_min_payment, :pfm_if_initial_length_set,
           :has_some_viable_rates, :has_some_affordable_prices

  def max_payment_less_than_min_payment
    errors.add(:max_payment, "cannot be less than the Min. payment") if max_payment < min_payment
  end

  def has_some_affordable_prices
    unless @viable_rates.size.zero?
      errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range" if no_affordable_prices?
    end
  end

  def no_affordable_prices?
#    @viable_rates already set by previous validation
    calc_rates_hash # now we should have access to @rates
    calc_effective_rates # @effective_rates
    calc_max_prices_given_rate # @max_prices_given_rate
    calc_affordable_prices
    @affordable_prices.length.zero?
  end

  def pfm_if_initial_length_set
    unless initial_period_length == nil
      errors[:base] << "Variable rate mortgages have no initial period length" unless loan_type == 'Partially Fixed Rate'
    end
  end

  def has_some_viable_rates
    set_viable_rates
    errors[:base] << "There are no rates in the system which match those conditions" if @viable_rates.size.zero?
  end
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

