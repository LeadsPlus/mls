class House < ActiveRecord::Base
  attr_accessible :title, :price, :bedrooms, :number, :street, :description, :county, :town, :image_url

  def address
    "#{number} #{street}, #{town}, Co. #{county}"
  end

  def ltv(princ)
    (princ*100)/price
  end
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
#  county      :string(255)
#  town        :string(255)
#  image_url   :string(255)
#  description :text
#  title       :string(255)
#

