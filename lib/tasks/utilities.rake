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
