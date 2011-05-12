require 'custom_validators/ample_max_payment_validator'
require 'custom_validators/vrm_and_initial_length_not_both_set_validator'

# I should really think about calculating the whole thing on creating and storing the answer
# I'm halfway there anyway

class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :county,
                  :loan_type, :initial_period_length, :lender
  attr_reader :viable_rates
  attr_accessor :max_mortgage

  before_validation { Rails.logger.debug "Validation begins here" }

#  by the time validation is finished, I already have everything up as far as get_affordable_mortgages
  after_validation do
    Rails.logger.debug "Validation Ends here"
#    do_everything
  end

  def calc_everything
    set_viable_rates # now we should have access to @viable_rates
    calc_rates_hash # now we should have access to @rates
#    calc_effective_rates # @effective_rates
    reject_morts
    calc_prices_given_rate # @prices_given_rate
    get_affordable_mortgages # @affordable_prices
    calc_best_mortgage # @best_price
#    calc_eventual_rate # @eventual_rate
    calc_min_price # @min_price
  end

#  this might be a bad idea if I'm breaking the lazy loading ability?
#  I think I'm ok since this returns a ActiveRecord::Relation object
  def set_viable_rates
    @viable_rates = Rate.scope_by_lender(lender)
                      .scope_by_loan_type(loan_type)
                      .scope_by_initial_period(initial_period_length)
    logger.debug "Viable rates set. #{@viable_rates.count} viable rates found"
  end

#  Cycle through every rate in the table and construct a hash with one entry for each LTV bracket
#  The value of the entry will be the lowest rate available in that LTV level
  def calc_rates_hash # build morts
    logger.debug "In the rates function"
#    format: minimum deposit % needed to get this rate => BigDecimal(rate)
    @mortgages = []
    @viable_rates.each do |rate|
#     make an array of the lowest rated mortgages for each deposit bracket
      @mortgages << Mortgage.new(rate, term)
    end
    logger.debug "Rates Hash Calculated:"
    @mortgages.inspect #.each {|m| m.log_debug }
#    rescue ActiveRecord::RecordNotFound
  end

  def reject_morts
    @mortgages = @mortgages.group_by{|m| m.rate.min_deposit }
                            .map { |min_deposit, mortgages| mortgages.min_by(&:avg_rate) }.flatten(1)
    @mortgages.inspect #.each {|m| m.log_debug }
  end

  def has_mortgage_conditions?
    logger.debug "Checking if has mortgage conditions"
    loan_type != 'Any' || initial_period_length != nil || lender != "Any"
  end
  
#  cycle through the effective rates hash, calculating the most expensive house we can afford
#  assuming we are able to buy at each particular rate, given the deposit we have to offer
  def calc_prices_given_rate
    @mortgages.each {|m| m.calc_price(max_payment, deposit) }
    Rails.logger.debug "Max prices calculated for each rate."
  end

#  cycle through the prices hash, rejecting prices that we can't actually afford
#  given the deposit we have to offer. Then select the setup which allows us the largest principal.
#    .max will give back [depos_percent, price]
#    .values.max will just give price
  def get_affordable_mortgages
#    deletes items for which the block is true
    @mortgages = @mortgages.delete_if { |mortgage| mortgage.unaffordable?(deposit) }
    
    logger.debug "Affordable Mortgages determined "
    if @mortgages.length > 0
      @mortgages.each do |mortgage|
        logger.debug mortgage
      end
    else
      logger.debug "There are no affordable prices"
    end
  end

  def calc_best_mortgage
#    now I need to reject all but the one which affords us the largest principal
#    using select! here is dangerous because it returns nil if no changes were made
#    this if there is only once affordable choice to begin with, we get returned nil
    @max_mortgage = @mortgages.sort! {|a,b| a.price <=> b.price }.pop
    logger.debug "Determined the best mortgage. #{@max_mortgage.price.truncate(2)}"
  end
  
  def calc_min_price
    @min_mortgage = Mortgage.new(@max_mortgage.rate, term)
    @min_mortgage.calc_price(min_payment, deposit)
    logger.debug "Calculated the min price as #{@min_mortgage.price.truncate(3)}"
  end

  def pmt_at(price)
    logger.debug "Getting a PMT for a house"
    calc_effective_rate(@eventual_rate) / ((1+calc_effective_rate(@eventual_rate))**(term*12)-1) *
        -((price-deposit)*((1+calc_effective_rate(@eventual_rate))**(term*12)))
  end

  def matches
    logger.debug "About to start finding matches"
    calc_everything
    logger.debug "Details used for finding matches: \n Min. Price: #{@min_mortgage.price.truncate(0)} \n"
    logger.debug "Max. Price: #{@max_mortgage.price.truncate(0)} \n County: #{county}"
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => @min_mortgage.price.truncate(0), :max => @max_mortgage.price.truncate(0), :county => county })
  end

  validates :max_payment, :presence => true,
                          :numericality => { :greater_than => 0, :allow_blank => true },
                          :ample_max_payment => { :unless => :anything_blank? }

  validates :min_payment, :presence => true,
                          :numericality => { :greater_than => 0, :allow_blank => true }

  validates :deposit, :presence => true,
                      :numericality => { :greater_than => 0, :allow_blank => true }

  validates :term, :presence => true,
                   :numericality => { :greater_than => 0, :less_than_or_equal_to => 60, :allow_blank => true }

  validates :county, :presence => true,
            :inclusion => { :in => %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down] }

  validates :loan_type, :vrm_and_initial_length_not_both_set => { :unless => "initial_period_length.blank?" }
  validates :lender, :inclusion => { :in => %w[Any 'Bank of Ireland' AIB 'Ulster Bank' 'Permanent TSB' ] }
  validates :loan_type, :inclusion => { :in => ['Variable Rate', "Partially Fixed Rate", "Any"] }
  validates :initial_period_length, :numericality => { :within => 0..100, :allow_nil => true, :allow_blank => true }

#  #  as far as I can tell, 'validate xyz' validations always happen before 'validates xyz' validations
#  @viable rates is built in 'has_some_viable_rates' and can then be used in 'has_some_affordable_prices'
  validate :has_some_viable_rates, :has_some_affordable_prices

  def anything_blank?
    max_payment.blank? || min_payment.blank? || deposit.blank? || term.blank?
  end

  def has_some_affordable_prices
    logger.debug "About to check for affordable prices"
    logger.debug "There are no blank attributes?: #{!anything_blank?}"
    return if anything_blank? or @viable_rates.size.zero?
    logger.debug "Validating that there are some affordable prices"
    errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range" if no_affordable_mortgages?
  end

  def no_affordable_mortgages?
#    @viable_rates already set by previous validation
    calc_rates_hash # now we should have access to @rates
#    calc_effective_rates # @effective_rates
    calc_prices_given_rate # @prices_given_rate
    get_affordable_mortgages
    logger.debug "There are some affordable prices?: #{!@affordable_mortgages.length.zero?}"
    @affordable_mortgages.length.zero?
  end

  def has_some_viable_rates
    return if anything_blank?
    set_viable_rates
    logger.debug "Validating the existance of some viable rates. Valid?: #{!@viable_rates.size.zero?}"
    errors[:base] << "There are no rates in the system which match those conditions" if @viable_rates.size.zero?
  end
end



# == Schema Information
#
# Table name: searches
#
#  id                    :integer         not null, primary key
#  max_payment           :integer
#  deposit               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  county                :string(255)
#  min_payment           :integer
#  term                  :integer
#  loan_type             :string(255)
#  initial_period_length :integer
#  lender                :string(255)
#

