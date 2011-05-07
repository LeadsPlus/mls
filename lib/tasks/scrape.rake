# ways to improve
# parse the address
# make it possible to not scrape sites, houses only

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  desc "Scrape house data from daft.ie"
  task :all => :environment do
    Rake::Task['db:reset'].invoke
    1.upto(32) do |county_id|
      Scrape.delay.county county_id.to_s
    end
    Rake::Task['db:populate'].invoke
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Scrape a single county based off it's ID"
  task :county, [:county_id] => :environment do |task, args|
    args.with_defaults(:county_id => 30)
    Scrape.delay.county args.county_id.to_s
  end
end