class Town < ActiveRecord::Base
  attr_accessible :name, :daft_id
  belongs_to :county
  has_many :houses

#  for some reason this raises a NoMethodError for county.name
#  perhaps there is a collision between Town.name and County.name ??
  def address
    "#{name}, Co. #{county.name}"
  end

  def self.reset
    Town.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.towns_id_seq', 1, false)"
  end

  def self.find_or_create_by_county_and_name(county, attributes)
    town = find_by_name_and_county_id(attributes[:name], county.id)
    unless town
      town = new(attributes)
      town.county = county
      town.save
    end
    town
  end

  def self.create_or_update_by_county_and_name(county, attributes)
    the_town = find_by_name_and_county_id(attributes[:name], county.id)
    if the_town
      the_town.update_attributes(attributes)
    else
      the_town = new(attributes)
      the_town.county = county
      the_town.save
    end
    the_town
  end

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

