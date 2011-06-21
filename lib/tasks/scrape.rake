# ways to improve
# parse the address
# make it possible to not scrape sites, houses only
# Took about 18 mins to visit 640 houses on heroku = 38.5 worker hours to visit every for sale house
#  38.5*0.05 = $2 to visit every house

# looks like 1k properties takes up about 1mb on the disk
require "scraper/scraper"
require "scraper/listings_scraper"
require "scraper/towns_scraper"
require "scraper/houses_scraper"
require "scraper/daft_search_result"
require "scraper/daft_house_page"
require "scraper/title_parser"
require "scraper/listings_scraper_job"

# TODO update these rake tasks to use the new Job clasees
namespace :scrape do
  desc "Enqueue jobs to scrape house listings for every county from daft.ie"
  task :all_listings => :environment do
    County.find_each() do |county|
      Scraper::ListingsScraper.new(county).refresh_listings
    end
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Enqueue a job to scrape a single county based off it's ID"
  task :listings_in, [:county_name] => :environment do |task, args|
    puts "Running task"
    args.with_defaults(:county_name => "Fermanagh")
    county = County.find_by_name args.county_name
    Delayed::Job.enqueue ListingsScraperJob.new(county)
  end

  desc "Visit the show page of all the houses in the database after a particular house id"
  task :houses_all => :environment do |task, args|
    County.find_each() do |county|
      Scraper::HousesScraper.new(county).visit_houses
    end
  end

  desc "Visit the show page of all the houses in a particular county"
  task :houses_in, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh") # 30 = Fermanagh
    county = County.find_by_name args.county_name
    Scraper::HousesScraper.new(county).visit_houses
  end

  desc "Scrape all valid town names from daft"
  task :all_towns => :environment do
    County.find_each() do |county|
      Scraper::TownsScraper.new(county).refresh_towns
    end
  end

  desc "Scrape all valid town names in a particular county from daft"
  task :towns_in, [:county_name] => :environment do |task, args|
    args.with_defaults(:county_name => "Fermanagh")
    county = County.find_by_name args.county_name
    Scraper::TownsScraper.new(county).refresh_towns
  end
end