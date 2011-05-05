class House < ActiveRecord::Base
  attr_accessible :title, :price, :bedrooms, :number, :street, :description, :county_id, :town, :image_url
  default_scope order('price')
  paginates_per 15

#  this doesn't work now because I have no access to the county_to_word helper
#  what if I was to add a county name column too and populate it just before save based off the county_id?
  def inline_address
    "#{number} #{street}, #{town}, Co. #{county_id}"
  end

  def ltv(princ)
    (princ*100)/price
  end

  validates :title, :presence => true
  validates :description, :presence => true

  validates :street, :presence => true
  validates :town, :presence => true
  validates :county_id, :presence => true,
                     :numericality => { :greater_than_or_equal_to => 0, :less_than => 32 }

  validates :price, :presence => true,
                    :numericality => { :greater_than => 1 }

  validates :number, :numericality => { :greater_than => 0 }
end



# == Schema Information
#
# Table name: houses
#
#  id          :integer         not null, primary key
#  street      :string(255)
#  price       :integer
#  bedrooms    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  number      :integer
#  town        :string(255)
#  image_url   :string(255)
#  description :text
#  title       :string(255)
#  county_id   :integer
#

