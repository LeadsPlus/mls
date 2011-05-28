# ways to improve
# parse the address
# make it possible to not scrape sites, houses only
# Took about 18 mins to visit 640 houses on heroku = 38.5 worker hours to visit every for sale house
#  38.5*0.05 = $2 to visit every house

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  desc "Enqueue jobs to scrape house data for every county from daft.ie"
  task :all => :environment do
    Scrape.new.all # the delay is in the county method
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Enqueue a job to scrape a single county based off it's ID"
  task :county, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh")
    county = County.find_by_name args.county_name
    Scrape.new.county county
  end

  desc "Visit the show page of all the houses in a particular county"
  task :visit_houses_in_county, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh") # 30 = Fermanagh
    county = County.find_by_name args.county_name
    Scrape.new.visit_houses_in_county(county)
  end

  desc "Visit the show page of all the houses in the database after a particular house id"
  task :visit_houses_starting_from, [:house_id] => :environment do |task, args|
    Scrape.new.visit_houses_starting_from args.house_id
  end

  desc "Scrape all valid the house locations from daft"
  task :locations => :environment do
    Town.delete_all
    Scrape.new.towns
  end
end