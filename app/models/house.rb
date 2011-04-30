class House < ActiveRecord::Base
  attr_accessible :address, :price, :bedrooms
end

# == Schema Information
#
# Table name: houses
#
#  id         :integer         not null, primary key
#  address    :string(255)
#  price      :integer
#  bedrooms   :integer
#  created_at :datetime
#  updated_at :datetime
#

