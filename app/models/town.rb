# It turns outt that since I'm back to using the select boxes to get town names,
# the region_name column is useless since I can't fill it from the selects.
# The only way I was able to filling it was creating towns when parsing titles
# but since I'm not doing that any more it can't be filled

class Town < ActiveRecord::Base
  attr_accessible :name, :daft_id, :county
  has_many :houses

  index do
    name
    county
  end

#  TODO when I try to add Kildare town in Kildare County. It adds every town in Kildare.
#  TODO I get an error when I search for 'Drogheda town centre'
  def self.search_except keywords, chosen_loc_ids
#    can't allow chosen_loc_ids to be null
    return search(keywords) if chosen_loc_ids.blank?
    where("towns.id NOT IN (?)", chosen_loc_ids.map{|t_id| t_id.to_i }).search(keywords)
  end

  def self.tsearch_except keywords, chosen_loc_ids
    return tsearch(keywords) if chosen_loc_ids.blank?
    where("towns.id NOT IN (?)", chosen_loc_ids.map{|t_id| t_id.to_i }).tsearch(keywords)
  end

#  TODO now that I'm searching across the town and county models, some of these methods
#  should be refactored to an agnostic location
#  When it's there, I can make chosen_loc_ids an instance variable with setter and getter
#  so I don't have to keep passing it around like I'm doing at the moment
  def self.controlled_search keywords, chosen_loc_ids
    county_search_results = County.search_except keywords, self.county_loc_ids(chosen_loc_ids)
#    county_search_results.county should be a binary result so this could be better
    return county_search_results if county_search_results.count > 0
    town_search_results = search_except keywords, self.town_loc_ids(chosen_loc_ids)
    return town_search_results if town_search_results.count > 0
    fuzzy_search_results = tsearch_except keywords, self.town_loc_ids(chosen_loc_ids)
    return fuzzy_search_results
  end

#  keep_if is equiv to select! but not select
  def self.county_loc_ids loc_ids
#    select returns an array containing the elements we want
    @county_loc_ids = loc_ids.select {|id| id[0] == 'c'}
  end

  def self.town_loc_ids loc_ids
    @town_loc_ids = loc_ids.select {|id| id[0] == 't'}
  end

  def address
    @address ||= "#{name}, #{county}"
  end

#  TODO validations

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

