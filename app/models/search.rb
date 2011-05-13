require 'custom_validators/ample_max_payment_validator'
require 'custom_validators/vrm_and_initial_length_not_both_set_validator'

# what if non-logged in users keep editing the same search but logged in users keep creating new ones

class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :county,
                  :loan_type, :initial_period_length, :lender, :max_price, :min_price
  attr_reader :viable_rates

  belongs_to :rate

  before_validation { logger.debug "Validation begins here" }

  before_save do
    logger.debug "About to create"
    keep_calculating
  end

#  by the time validation is finished, I already have everything up as far as get_affordable_mortgages
  def keep_calculating
    find_best_mortgage
    self.max_price = @max_mortgage.price.to_i
    self.min_price = calc_min_price.to_i
  end

  def set_viable_rates
    @viable_rates = Rate.scope_by_lender(lender)
                      .scope_by_loan_type(loan_type)
                      .scope_by_initial_period(initial_period_length)
    logger.debug "Viable rates set. #{@viable_rates.count} viable rates found"
  end

#  If I limit people to preset term lengths, I can pre-calulate average rates, skip the calc_rates_hash
#  method and only instanciate mortgages for compeditive rates
  def reject_morts
    @viable_rates = @viable_rates.group_by{|r| r.min_deposit }
                        .map { |min_deposit, rates| rates.min_by(&:twenty_year_apr) }.flatten(1)
    logger.debug @viable_rates
    @mortgages = []
    @viable_rates.each do |rate|
      @mortgages << Mortgage.new(rate, term, deposit, max_payment)
    end
    logger.debug "Mortgages built"
  end

  def has_mortgage_conditions?
    logger.debug "Checking if has mortgage conditions"
    loan_type != 'Any' || initial_period_length != nil || lender != "Any"
  end
  
  def calc_prices_given_rate
    @mortgages.each {|m| m.calculate_price }
    logger.debug "Max prices calculated for each rate."
  end

  def get_affordable_mortgages
#    deletes items for which the block is true
    @affordable_mortgages = @mortgages.delete_if { |mortgage| mortgage.unaffordable? }
  end

  def find_best_mortgage
#    now I need to reject all but the one which affords us the largest principal
#    using select! here is dangerous because it returns nil if no changes were made
#    this if there is only once affordable choice to begin with, we get returned nil
    @max_mortgage = @affordable_mortgages.sort! {|a,b| a.price <=> b.price }.pop
    self.rate = @max_mortgage.rate
    logger.debug "Determined the best mortgage. #{@max_mortgage.price.truncate()}"
  end
  
  def calc_min_price
    @min_mortgage = Mortgage.new(@max_mortgage.rate, term, deposit, min_payment).calculate_price
  end

  def matches
    logger.debug "About to start finding matches"
    logger.debug "Details used for finding matches: \n Min. Price: #{min_price} \n"
    logger.debug "Max. Price: #{max_price} \n County: #{county}"
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => min_price, :max => max_price, :county => county })
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
            :inclusion => { :in => COUNTIES }

  validates :loan_type, :vrm_and_initial_length_not_both_set => { :unless => "initial_period_length.blank?" }
  validates :lender, :inclusion => { :in => Array.new(LENDERS) << "Any" }
  validates :loan_type, :inclusion => { :in => Array.new(LOAN_TYPES) << "Any" }
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
#    calc_rates_hash
    reject_morts
    calc_prices_given_rate
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
#  max_price             :integer
#  min_price             :integer
#  rate_id               :integer
#

