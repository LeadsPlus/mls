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
  def self.search_except keywords, town_ids
#    can't allow town_ids to be null
    return search(keywords) if town_ids.blank?
    where("towns.id NOT IN (?)", town_ids.map{|t_id| t_id.to_i }).search(keywords)
  end

  def self.tsearch_except keywords, town_ids
    return tsearch(keywords) if town_ids.blank?
    where("towns.id NOT IN (?)", town_ids.map{|t_id| t_id.to_i }).tsearch(keywords)
  end

  def self.controlled_search keywords, town_ids
    search_results = search_except keywords, town_ids
    return search_results if search_results.count > 0
    fuzzy_search_results = tsearch_except keywords, town_ids
    return fuzzy_search_results
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

