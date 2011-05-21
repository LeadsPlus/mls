class House < ActiveRecord::Base
  attr_accessible :price, :description, :county, :image_url, :daft_id,
                  :property_type, :daft_title, :daft_date_entered, :bedrooms,
                  :bathrooms, :address
  default_scope order("#{table_name}.price desc")
  paginates_per(10)
  has_many :photos, :dependent => :destroy

  index do
    daft_title
  end

  def title
#    unless address.blank? || property_type.blank?
#      return "#{address} - #{property_type}"
#    end
    daft_title
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

#  validates :title, :presence => true

  validates :county, :presence => true,
      :inclusion => { :in => COUNTIES }

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
#  county            :string(255)
#  image_url         :string(255)
#  description       :text
#  daft_title        :string(255)
#  daft_id           :integer
#  bedrooms          :integer
#  bathrooms         :integer
#  daft_date_entered :date
#  address           :string(255)
#  property_type     :string(255)
#

