# I need to gradually wean this model off the county field, onto the county class/model
# property_type should be renamed to just type
# daft_date_entered should be deleted

class House < ActiveRecord::Base
  attr_accessible :price, :description, :county_id, :image_url, :daft_id,
                  :property_type, :daft_title, :daft_date_entered, :bedrooms,
                  :bathrooms, :address, :town_id
  attr_reader :payment_required
  
  paginates_per(10)
  has_many :photos, :dependent => :destroy
  belongs_to :county
  belongs_to :town

  index do
    daft_title
  end

  def title
    "#{address} #{town.name}, Co. "
  end

  def county_index
    @county_index = daft_title.rindex(/, Co\./)
  end

  def title_sans_county
#    this will try to strip from 0 to nil if regex misses!?
    @title_sans_county ||= daft_title[0, county_index]
  end

  def county_onwards
    @county_onwards ||= daft_title[county_index, daft_title.length]
  end

  def stripped_town
#    this only matches one letter if you remove the " " prefix
    title_sans_county[title_sans_county.rindex(/, \w+/), title_sans_county.length].gsub(/, /, '')
  end

#  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
  def property_type_portion
    @property_type_portion ||= parse_property_type_portion
  end

#  this returns the index of the " - " just after county else nil if doesn't exist
  def property_type_index
    @property_type_index ||= county_onwards.rindex(/ - /)
  end

#  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
  def parse_property_type_portion
    unless property_type_index.nil?
      daft_title[property_type_index, daft_title.length]
    end
  end

#  returns the property type
  def type
    @type ||= parse_type
  end

#  finds the corresponding house type in the HOUSE_TYPES array
#  this works because HOUSE_TYPES is set up in such a way that no type includes another as a substring
#  some properties have no type
#  some properties have " - " in the freeform address part, hence matching this (only) cannot be relied on
  def parse_type
    puts "Daft_id: #{daft_id}, Type string: #{property_type_portion}"
    unless property_type_portion.nil?
      HOUSE_TYPES.each do |type|
        return type if property_type_portion.include? type
      end
    end
#    returns nil if we make it to here
  end

  def daft_url
    "http://www.daft.ie/searchsale.daft?id=#{daft_id}"
  end

  def ltv(princ)
    (princ*100)/price
  end

  def self.cheaper_than price
    where('houses.price <= ?', price)
  end

  def self.more_expensive_than price
    where('houses.price >= ?', price)
  end

  def calc_payment_required_assuming rate, term, users_deposit
    @payment_required ||= Mortgage.new(rate, term, users_deposit, self.price).payment_required
  end

#  validates :county, :presence => true,
#      :inclusion => { :in => COUNTIES }

#  validates :county_id, :presence => true, :numericality => { within: 1..32 }

  validates :price, :presence => true,
                    :numericality => { :greater_than => 1 }

  validates :daft_id, :presence => true,
                      :numericality => { :greater_than => 0 }

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
#  daft_date_entered :date
#  address           :string(255)
#  property_type     :string(255)
#  county_id         :integer
#  town_id           :integer
#

