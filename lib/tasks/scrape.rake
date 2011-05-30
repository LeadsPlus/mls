# ways to improve
# parse the address
# make it possible to not scrape sites, houses only
# Took about 18 mins to visit 640 houses on heroku = 38.5 worker hours to visit every for sale house
#  38.5*0.05 = $2 to visit every house

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  desc "Enqueue jobs to scrape house listings for every county from daft.ie"
  task :all_listings => :environment do
    Scrape.new.refresh_listings_in(County.all) # the delay is in the county method
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Enqueue a job to scrape a single county based off it's ID"
  task :listings_in, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh")
    county = County.find_by_name args.county_name
    Scrape.new.refresh_listings_in(county)
  end

  desc "Visit the show page of all the houses in the database after a particular house id"
  task :visit_all => :environment do |task, args|
    Scrape.new.visit_houses_in County.all
  end

  desc "Visit the show page of all the houses in a particular county"
  task :visit_in, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh") # 30 = Fermanagh
    county = County.find_by_name args.county_name
    Scrape.new.visit_houses_in(county)
  end

  desc "Scrape all valid town names from daft"
  task :all_towns => :environment do
    Scrape.new.refresh_towns_in County.all
  end

  desc "Scrape all valid town names in a particular county from daft"
  task :towns_in, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh")
    county = County.find_by_name args.county_name
    Scrape.new.refresh_towns_in county
  end
end