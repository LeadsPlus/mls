class House < ActiveRecord::Base
  attr_accessible :title, :price, :description, :county, :image_url, :daft_url
  default_scope order('price')
  paginates_per(10)

#  this doesn't work now because I have no access to the county_to_word helper
#  what if I was to add a county name column too and populate it just before save based off the county_id?
  def inline_address
    "#{number} #{street}, #{town}, Co. #{county}"
  end

  def ltv(princ)
    (princ*100)/price
  end

  validates :title, :presence => true

  validates :county, :presence => true

  validates :price, :presence => true,
                    :numericality => { :greater_than => 1 }

end





# == Schema Information
#
# Table name: houses
#
#  id          :integer         not null, primary key
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  image_url   :string(255)
#  description :text
#  title       :string(255)
#  daft_url    :string(255)
#  county      :string(255)
#

