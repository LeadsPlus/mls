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

  def self.search_except keywords, excluded_ids
#    can't allow chosen_loc_ids to be null
    return search(keywords) if excluded_ids.empty?
    where("towns.id NOT IN (?)", excluded_ids).search(keywords)
  end

  def self.tsearch_except keywords, excluded_ids
    Rails.logger.debug "Fuzzy search with keys: #{keywords} and exclusions #{excluded_ids}"
    return tsearch(keywords) if excluded_ids.empty?
    Rails.logger.debug "Past the fuzzy search return"
    where("towns.id NOT IN (?)", excluded_ids).tsearch(keywords)
  end

#  the locations controller needs to be updated anytime this method is changed
  def identifying_string
    @identifying_string ||= "#{name}, Co. #{county}"
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

