# I need to gradually wean this model off the county field, onto the county class/model
# property_type should be renamed to just type
# daft_date_entered should be removed, it's useless

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
    "#{address}, #{town.name}, Co. #{county.name}"
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

  def payment_required rate, term, users_deposit
    Mortgage.new(rate, term, users_deposit, self.price).payment_required
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

