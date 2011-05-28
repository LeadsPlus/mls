#I guess this can be replaced by an array of hashes?

class County < ActiveRecord::Base
  attr_accessible :name, :daft_id
  has_many :houses
  has_many :towns
end

# == Schema Information
#
# Table name: counties
#
#  id         :integer         not null, primary key
#  daft_id    :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# daft_id == id

