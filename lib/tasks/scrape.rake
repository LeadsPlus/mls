# ways to improve
# parse the address
# make it possible to not scrape sites, houses only

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  desc "Enqueue jobs to scrape house data for every county from daft.ie"
  task :all => :environment do
    Scrape.new.all # the delay is in the county method
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Enqueue a job to scrape a single county based off it's ID"
  task :county, [:daft_county_id] => :environment do |task, args|
    args.with_defaults(:daft_county_id => 30) # 30 = Fermanagh
    Scrape.new.county args.daft_county_id.to_s
  end

  desc "Visit the show page of all the houses in a particular county"
  task :visit_houses_in_county, [:daft_county_id] => :environment do |task, args|
    args.with_defaults(:daft_county_id => 30) # 30 = Fermanagh
    Scrape.new.visit_houses_in_county(args.daft_county_id)
  end

  desc "Visit the show page of all the houses in the database after a particular house id"
  task :visit_houses_starting_from, [:house_id] => :environment do |task, args|
    Scrape.new.visit_houses_starting_from args.house_id
  end
end