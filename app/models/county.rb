#I guess this can be replaced by an array of hashes?
# move county scraping methods in here?? County.scrape_listings_in("Fermanagh") OR County.find("Fernamagh").scrape_listings
# Or leave it in the scrape class but allow access from here??

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

