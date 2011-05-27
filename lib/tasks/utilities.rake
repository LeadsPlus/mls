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
  House.find_each() do |house|
    correct_town = nil
#    THis is broken by the County indexing offset issue
    Town.find_all_by_county_id(30).each do |town|
#      Lack comes after Eniskillan, it finds Eniskillan first and sets correct_town and keeps going
#      Then it finds Lack and overwrites correct_town. After loop, Lack gets passed back as the town
#      Need to iterate over the words in the daft_title OR
#      strip back as far as the county. The town will be the next word along
      unless house.daft_title.rindex(town.name).nil?
#      rindex == reverse index
        correct_town = town
      end
    end
    puts "Nil town found for #{house.daft_title}" if correct_town.nil?
    house.town = correct_town
    house.save!
  end
end