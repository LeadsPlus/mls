# option 1: Just store an array of included (perhaps excluded) mortgage types in a db column. AR Serialize
# the problem is that, bound check boxes respond to boolean model columns, which doesn't really work
# virtual attribute? Custom form builder?
# <input name="search[:lenders][]" />
# <input name="search[:lenders][]" />
# this will result in search[:lenders] == Array
# unchecked checkboxes sbmit no value
# 


require 'custom_validators/ample_max_payment_validator'
#require 'custom_validators/is_valid_lender_validator'
require 'custom_validators/vrm_and_initial_length_not_both_set_validator'

# what if non-logged in users keep editing the same search but logged in users keep creating new ones

class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :term, :location,
                  :loan_type, :initial_period_length, :lender, :max_price, :min_price
  attr_reader :viable_rates
  belongs_to :rate
  serialize :lender
  serialize :loan_type

  before_save do
    logger.debug "About to save the search"
    keep_calculating
  end

  before_validation do
    logger.debug "Lender #{lender}"
  end

#  I think there's a way I can put these calcs in the reader methods for the attributes
#  so that if they're present in the DB we read from there
#  but if we're saving, it will calc them
  def keep_calculating
    self.max_price = broker.max_mortgage.price.to_i
    self.min_price = broker.min_mortgage.price.to_i
    self.rate = broker.max_mortgage.rate
  end

#  maybe I just pass in the Search object instead?
  def broker
    @broker ||= MortgageBroker.new(term, deposit, max_payment, min_payment, lender, loan_type, initial_period_length)
  end
  
  def has_mortgage_conditions?
    logger.debug "Checking if has mortgage conditions"
    loan_type != LOAN_TYPES || lender != LENDERS
  end

#  potential problems I see with this implementation
#  One, I don't think it lazy loads, which means that I'm working on an array in memory. Could be problem
  def matches
    logger.debug "Finding matches"
    House.search(location).cheaper_than(max_price).more_expensive_than(min_price)
  end

  validates :max_payment, :presence => true,
                          :numericality => { greater_than: 0, allow_blank: true },
                          :ample_max_payment => { unless: :anything_blank? }

  validates :min_payment, :presence => true,
                          :numericality => { greater_than: 0, allow_blank: true }

  validates :deposit, :presence => true,
                      :numericality => { greater_than: 0, allow_blank: true }

  validates :term, :presence => true,
                   :numericality => { greater_than: 0, less_than_or_equal_to: 60, allow_blank: true }

  validates :location, presence: true, length: { maximum: 254, minimum: 1, allow_blank: true }

#  validates :lender, :is_valid_lender => true
#  validates :loan_type, :inclusion => { :in => LOAN_TYPES }

#  #  as far as I can tell, 'validate xyz' validations always happen before 'validates xyz' validations
#  @viable rates is built in 'has_some_viable_rates' and can then be used in 'has_some_affordable_prices'
  validate :has_some_viable_rates, :has_some_affordable_prices

  def anything_blank?
    max_payment.blank? || min_payment.blank? || deposit.blank? || term.blank?
  end

  def has_some_affordable_prices
    logger.debug "Checking for affordable prices"
    return if anything_blank? or broker.has_no_viable_rates?
#    we have an problem if the mortgage broker has no affordable mortgages for us
    unless broker.has_affordable_mortgages?
      errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range"
    end
  end

  def has_some_viable_rates
    return if anything_blank?
    logger.debug "Checking for viable rates"
    unless broker.has_viable_rates?
      errors[:base] << "There are no rates in the system which match those conditions"
    end
  end

  def is_valid_lender_validator
    logger.debug "Checking lenders are valid"
    lender.each do |lender|
      errors[:lender] << "is invalid" unless LENDERS.include?(lender)
    end
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
#  location              :string(255)
#  min_payment           :integer
#  term                  :integer
#  loan_type             :string(255)
#  initial_period_length :integer
#  lender                :string(255)
#  max_price             :integer
#  min_price             :integer
#  rate_id               :integer
#

