class Town < ActiveRecord::Base
  attr_accessible :name, :daft_id, :county
  has_many :houses

# I think that what's happening is that the route for this is a collection, therefore it's accessing the
#  whole Town list, not a specific town. The town list as a whole doesn't have an associated county obviously
#  doing Town.find_by_name(name).county.name isn't perfect either because if a town is registered to two counties
#  we could be finding either one of them first
#  I think this may be the evidence I need that AR County model is wrong
#  The solution to this particular issue is to store county name in the town table
  def town_address
    @address ||= "#{name}, Co. #{county}"
  end

  def self.reset
    Town.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.towns_id_seq', 1, false)"
  end

  def self.find_or_create_by_county_and_name(attributes)
    town = find_by_name_and_county(attributes[:name], attributes[:county])
    unless town
      town = new(attributes)
      town.save
    end
    town
  end

  def self.create_or_update_by_county_and_name(attributes)
    the_town = find_by_name_and_county(attributes[:name], attributes[:county])
    if the_town
      attributes = attributes.delete_if {|k,v| v.nil? }
      the_town.update_attributes(attributes)
      the_town.save
    else
      the_town = new(attributes)
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
#  name       :string(255)
#  daft_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  county     :string(255)
#

