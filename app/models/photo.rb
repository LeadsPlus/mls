class Photo < ActiveRecord::Base
  attr_accessible :url, :height, :width
  belongs_to :house

  validates :url, :uniqueness => { :case_sensitive => false }
end

# == Schema Information
#
# Table name: photos
#
#  id         :integer         not null, primary key
#  house_id   :integer
#  url        :string(255)
#  width      :integer
#  height     :integer
#  created_at :datetime
#  updated_at :datetime
#

