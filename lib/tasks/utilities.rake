namespace :houses do
  desc "Change all the house daft_urls into daft_id's"
  task :convert_daft_urls => :environment do
    delay.convert_urls_to_ids
  end

  desc "Make up fake room numbers for all the houses in the DB"
  task :fake_rooms => :environment do
    fake_rooms
  end

  desc "Convert all the county names to their appropriate id"
  task :convert_county_names => :environment do
    convert_counties_to_foreign_keys
  end

  desc "Create relationships between towns and previously scraped houses"
  task :parse_address => :environment do
    parse_address
  end
end

def convert_urls_to_ids
  House.find_each(:batch_size => 2000) do |house|
    house.daft_url.match(/[0-9]+/) do |id|
      house.daft_id = id[0].to_i
      house.save!
    end
  end
end

def fake_rooms
  House.find_each() do |house|
    house.bathrooms = 1+rand(4)
    house.bedrooms = 1+rand(6)
    house.save!
  end
end

def convert_counties_to_foreign_keys
  House.find_each() do |house|
    house.county_id = (COUNTIES.index house.county) + 1
    house.save!
  end
end

#  lord what a horrendous implementation!
  def find_town
    puts self.daft_title
    possible_towns = self.county.towns.all # array
#    daft title.index returns the index of the first occurance of the substring in the daft_title
#    else it returns nil. Obv index evals true and nil false
#    possible_towns.index returns the index of the first town in the array for which the block evals true
#    if it nevers evals true, it returns nil
    blah = possible_towns.index{|town| self.daft_title.index(town.name) }
    possible_towns[blah] unless blah.nil?
  end

def parse_address
  House.find_each() do |h|
    stripped_county = h.daft_title[0, h.daft_title.rindex(/, Co\./)]
    town_index = stripped_county.rindex(/, \w+/)
    town_name = stripped_county[town_index, stripped_county.length].gsub(/, /, '')
    address = stripped_county[0, town_index]
    town = Town.find_by_name(town_name)

#    puts "TItle: #{h.daft_title}"
#    puts "Town name: #{town_name}"
#    puts "address: #{address}"
#    puts "Town: #{town.name}"
    h.address = address
    h.town = town
    h.save!
  end
end