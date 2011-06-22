#I guess this can be replaced by an array of hashes?
# move county scraping methods in here?? County.scrape_listings_in("Fermanagh") OR County.find("Fernamagh").scrape_listings
# Or leave it in the scrape class but allow access from here??
class County < ActiveRecord::Base
  attr_accessible :name, :daft_id
  has_many :houses

  index do
    name
  end

  def towns
    Town.where(:county => county)
  end

#  the locations controller needs to be updated anytime this method is changed
  def identifying_string
    @identifying_string ||= "Anywhere in Co. #{name}"
  end

  def self.search_except keywords, excluded_ids
    return search(keywords) if excluded_ids.empty?
    where("counties.id NOT IN (?)", excluded_ids).search(keywords)
  end

  def self.reset
    County.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.counties_id_seq', 1, false)"
  end
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

