require 'log'
# there must be a way I can include these more cleanly
require "finance/mortgage_broker"
require "finance/financial_product"
require "finance/reverse_mortgage"
require "custom_validators"
# what if non-logged in users keep editing the same search but logged in users keep creating new ones

class Search < ActiveRecord::Base
  include CustomValidators
  include Log
  attr_accessible :min_payment, :max_payment, :deposit, :term, :locations, :bedrooms, :bathrooms,
                  :loan_type_uids, :lender_uids, :max_price, :min_price, :property_type_ids
  attr_reader :viable_rates
  belongs_to :rate; belongs_to :usage
  serialize :lender_uids; serialize :loan_type_uids; serialize :bedrooms
  serialize :bathrooms; serialize :locations; serialize :property_type_ids
  
  before_validation :invert_property_type_ids
  before_save :keep_calculating

  def invert_property_type_ids
    Rails.logger.debug "Current Property Types: #{property_type_ids}"
    not_included_types = PropertyType.not_in property_type_ids
    Rails.logger.debug "Not included Property Types: #{not_included_types}"
    # Neet to put the self.pro.. otherwise it doesn't actually get set
    self.property_type_ids = not_included_types
  end

  def location_objects
    locations.map do |location|
      if location[0] == 't'
#        TODO it might be better to utalise the 'excluded_county_ids' methods found in Locations and only hit the DB once
        Town.find(location.gsub(/\D/, '').to_i)
      elsif location[0] == 'c'
        County.find location.gsub(/\D/, '').to_i
      end
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

#  TODO maybe I just pass in the Search object instead?
  def broker
    @broker ||= Finance::MortgageBroker.new(term, deposit, max_payment, min_payment, lender_uids, loan_type_uids)
  end

#  TODO am I using these functions?
  def has_loan_type_conditions?
    loan_type_uids != LOAN_TYPE_UIDS
  end

  def has_lender_conditions?
    lender_uids != LENDER_UIDS
  end

  def has_prop_type_conditions?
    prop_type_uids != PropertyType.uids
  end

  def has_bedroom_conditions?
    bedrooms != BEDROOMS
  end

  def has_bathroom_conditions?
    bathrooms != BATHROOMS
  end

  def matches
    log_around('search for matches') do
      House.in(locations).cheaper_than(max_price)
        .more_expensive_than(min_price).has_baths(bathrooms)
        .has_beds(bedrooms).not_of_type(property_type_ids)
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

  validates :locations, presence: true, valid_locations: true, serializable_ints: true

  validates :lender_uids, presence: true, serializable_strings: true
  validates :loan_type_uids, presence: true, serializable_strings: true
# TODO come up with a format validation for property_type_uids
  validates :bedrooms, presence: true, serializable_ints: true
  validates :bathrooms, presence: true, serializable_ints: true
  validate :has_some_viable_rates, :has_some_affordable_prices

#  this may not be a perfect implementation since 0 != blank
#  also, there are not far more attributes which may not be blank
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

  def is_valid_lender_uid_validator
    log_around 'to validate lenders array' do
      lender_uids.each do |lender_uid|
        errors[:lender] << "is invalid" unless LENDER_UIDS.include?(lender)
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
#  id                :integer         not null, primary key
#  max_payment       :integer
#  deposit           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  locations         :string(400)
#  min_payment       :integer
#  term              :integer
#  loan_type_uids    :string(255)
#  lender_uids       :string(255)
#  max_price         :integer
#  min_price         :integer
#  rate_id           :integer
#  bedrooms          :string(255)
#  bathrooms         :string(255)
#  property_type_ids :string(255)
#  usage_id          :integer
#

