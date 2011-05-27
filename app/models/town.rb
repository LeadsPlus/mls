class Town < ActiveRecord::Base
  belongs_to :county
  has_many :houses

#  require town names to be unique? What if there is a county with two towns the same name?
end


# == Schema Information
#
# Table name: towns
#
#  id         :integer         not null, primary key
#  county_id  :integer
#  name       :string(255)
#  daft_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

