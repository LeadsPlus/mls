require 'custom_validators/ample_max_payment_validator'
require 'custom_validators/vrm_and_initial_length_not_both_set_validator'

# what if non-logged in users keep editing the same search but logged in users keep creating new ones

class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :county,
                  :loan_type, :initial_period_length, :lender, :max_price, :min_price
  attr_reader :viable_rates

  belongs_to :rate

  before_save do
    logger.debug "About to save the search"
    keep_calculating
  end

#  by the time validation is finished, I already have everything up as far as affordable_mortgages
  def keep_calculating
    self.max_price = max_mortgage.price.to_i
    self.min_price = min_mortgage.price.to_i
    self.rate = max_mortgage.rate
  end

  def viable_rates
    @viable_rates ||= Rate.scope_by_lender(lender)
                      .scope_by_loan_type(loan_type)
                      .scope_by_initial_period(initial_period_length)
  end

#  If I limit people to preset term lengths, I can pre-calulate average rates, skip the calc_rates_hash
#  method and only instanciate mortgages for compeditive rates
  def lowest_rates
    @lowest_rates ||= viable_rates.group_by{|r| r.min_deposit }
                        .map { |min_deposit, rates| rates.min_by(&:twenty_year_apr) }.flatten(1)
  end

  def mortgages
    unless @mortgages
      logger.debug "Building the mortgage objects"
      @mortgages = []
      lowest_rates.each do |rate|
        @mortgages << ReverseMortgage.new(rate, term, deposit, max_payment)
      end
    end
    logger.debug "Returning the mortgages"
    @mortgages
  end

  def has_mortgage_conditions?
    logger.debug "Checking if has mortgage conditions"
    loan_type != 'Any' || initial_period_length != nil || lender != "Any"
  end

  def affordable_mortgages
    logger.debug "Removing unaffordable mortgages"
#    deletes items for which the block is true
    @affordable_mortgages ||= mortgages.delete_if { |mortgage| mortgage.unaffordable }
  end

  def max_mortgage
    logger.debug "Selecting the mortgage with the max affordable price"
    @max_mortgage ||= affordable_mortgages.sort! {|a,b| a.price <=> b.price }.pop
  end
  
  def min_mortgage
    @min_mortgage ||= ReverseMortgage.new(max_mortgage.rate, term, deposit, min_payment)
  end

#  potential problems I see with this implementation
#  One, I don't think it lazy loads, which means that I'm working on an array in memory. Could be problem
  def matches
    logger.debug "Finding matches"
    House.search(county).cheaper_than(max_price).more_expensive_than(min_price)
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

  validates :county, :presence => true
#            :inclusion => { :in => COUNTIES }

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
    return if anything_blank? or viable_rates.size.zero?
    errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range" if affordable_mortgages.length.zero?
  end

  def has_some_viable_rates
    return if anything_blank?
    logger.debug "Validating the existance of some viable rates. Valid?: #{!viable_rates.size.zero?}"
    errors[:base] << "There are no rates in the system which match those conditions" if viable_rates.size.zero?
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

