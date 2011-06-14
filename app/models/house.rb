# I need to gradually wean this model off the county field, onto the county class/model
# property_type should be renamed to just type
# daft_date_entered should be removed, it's useless
require "finance/financial_product"
require "finance/mortgage"

class House < ActiveRecord::Base
  attr_accessible :price, :description, :county_id, :image_url, :daft_id,
                  :property_type, :property_type_uid, :daft_title, :bedrooms,
                  :bathrooms, :address, :town_id, :region_name
  attr_reader :payment_required
  
  paginates_per(10)
  has_many :photos, :dependent => :destroy
  belongs_to :county
  belongs_to :town

  before_create :set_property_type_uid

  def set_property_type_uid
    self.property_type_uid = PropertyType.convert_to_uid(property_type)
  end

  def title
    "#{address}, #{town.name}, Co. #{county.name}"
  end
  
  def daft_url
    "http://www.daft.ie/searchsale.daft?id=#{daft_id}"
  end

  def self.in town_ids
    where('houses.town_id' => town_ids)
  end

  def self.cheaper_than price
    where('houses.price <= ?', price)
  end

  def self.more_expensive_than price
    where('houses.price >= ?', price)
  end

  def self.has_baths(bathrooms)
    where(:"houses.bathrooms" => bathrooms)
  end

  def self.has_humble_beds(bedrooms)
    where(:"houses.bedrooms" => bedrooms)
  end

  def self.has_loads_of_beds
    where "houses.bedrooms > ?", 5
  end

  def self.has_beds(bedrooms)
    logger.debug "Has these bedrooms #{bedrooms.to_s}"
    logger.debug "Does it include more? #{bedrooms.include? 'more'}"
    return has_humble_beds(bedrooms) unless bedrooms.include?('more')
#    have to use AREL to make an OR chain
    where(arel_table[:bedrooms].in(bedrooms).or(arel_table[:bedrooms].gt(5)))
  end

  def self.property_type_is_one_of(prop_type_uids)
    where(:property_type_uid => prop_type_uids)
  end

  def payment_required rate, term, users_deposit
    Finance::Mortgage.new(rate, term, users_deposit, self.price).payment_required
  end

#  doing extensive validations at this point is dangerous since I'm using a scraper
#  which leads to whacky results. I don't want to drop houses because of it.
  validates :county_id, presence: true, numericality: true

  validates :price, :presence => true,
                    :numericality => { :greater_than => 1 }

  validates :daft_id, :presence => true,
                      :numericality => { :greater_than => 0 }

  def self.reset
    House.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.houses_id_seq', 1, false)"
  end

end





# == Schema Information
#
# Table name: houses
#
#  id                :integer         not null, primary key
#  price             :integer
#  created_at        :datetime
#  updated_at        :datetime
#  image_url         :string(255)
#  description       :text
#  daft_title        :string(255)
#  daft_id           :integer
#  bedrooms          :integer
#  bathrooms         :integer
#  address           :string(255)
#  property_type     :string(255)
#  county_id         :integer
#  town_id           :integer
#  last_scrape       :integer
#  property_type_uid :string(255)
#  region_name       :string(255)
#

