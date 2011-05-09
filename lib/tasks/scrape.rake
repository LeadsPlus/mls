# ways to improve
# parse the address
# make it possible to not scrape sites, houses only

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  desc "Enqueue jobs to scrape house data for every county from daft.ie"
  task :all => :environment do
    Rake::Task['db:reset'].invoke
    Scrape.new.all
    Rake::Task['db:populate'].invoke
  end

#  the numbers in the daft URLs are probably a UID, perhaps I can use these to only scrape new houses
#  when i do my second and future run throughs. Could also use it to remove sold houses
  desc "Enqueue a job to scrape a single county based off it's ID"
  task :county, [:daft_county_id] => :environment do |task, args|
    args.with_defaults(:daft_county_id => 30) # 30 = Fermanagh
    Scrape.new.county args.daft_county_id.to_s
  end
end