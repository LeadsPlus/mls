require 'log'
# there must be a way I can include these more cleanly
require "finance/mortgage_broker"
require "finance/financial_product"
require "finance/reverse_mortgage"
require 'custom_validators/ample_max_payment_validator'
#require 'custom_validators/is_valid_lender_validator'
require 'custom_validators/vrm_and_initial_length_not_both_set_validator'

# what if non-logged in users keep editing the same search but logged in users keep creating new ones

class Search < ActiveRecord::Base
  include Log
  attr_accessible :min_payment, :max_payment, :deposit, :term, :location, :bedrooms, :bathrooms,
                  :loan_type, :initial_period_length, :lender, :max_price, :min_price
  attr_reader :viable_rates
  belongs_to :rate
  serialize :lender
  serialize :loan_type
  serialize :bedrooms
  serialize :bathrooms

  before_save do
    log_around("keep calculating") do
      keep_calculating
    end
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
    @broker ||= Finance::MortgageBroker.new(term, deposit, max_payment, min_payment, lender, loan_type, initial_period_length)
  end
  
  def has_mortgage_conditions?
    log_around('check for mortgage conditions') do
      loan_type != LOAN_TYPES || lender != LENDERS
    end
  end

#  potential problems I see with this implementation
#  One, I don't think it lazy loads, which means that I'm working on an array in memory. Could be problem
  def matches
    log "bedrooms #{bedrooms}"
    log "bathrooms #{bathrooms}"
    log_around('search for matches') do
      House.search(location).cheaper_than(max_price)
        .more_expensive_than(min_price).has_baths(bathrooms)
        .has_beds(bedrooms)
    end
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
#  validation for bathrooms and bedrooms needed
#  validates :lender, :is_valid_lender => true
#  validates :loan_type, :inclusion => { :in => LOAN_TYPES }

#  #  as far as I can tell, 'validate xyz' validations always happen before 'validates xyz' validations
#  @viable rates is built in 'has_some_viable_rates' and can then be used in 'has_some_affordable_prices'
  validate :has_some_viable_rates, :has_some_affordable_prices

  def anything_blank?
    max_payment.blank? || min_payment.blank? || deposit.blank? || term.blank?
  end

  def has_some_affordable_prices
    return if anything_blank? or broker.has_no_viable_rates?
    log_around('test for affordable prices') do
  #    we have an problem if the mortgage broker has no affordable mortgages for us
      unless broker.has_affordable_mortgages?
        errors[:base] << "Deposit is too small to facilitate a mortgage with payments in that range"
      end
    end
  end

  def has_some_viable_rates
    return if anything_blank?
    log_around('check for viable rates') do
      unless broker.has_viable_rates?
        errors[:base] << "There are no rates in the system which match those conditions"
      end
    end
  end

  def is_valid_lender_validator
    log_around 'to validate lenders array' do
      lender.each do |lender|
        errors[:lender] << "is invalid" unless LENDERS.include?(lender)
      end
    end
  end

  def self.reset
    Search.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.searches_id_seq', 1, false)"
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

