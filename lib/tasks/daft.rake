# ways to improve
# parse the address
# make it possible to not scrape sites, houses only

# looks like 1k properties takes up about 1mb on the disk
namespace :scrape do
  require "nokogiri"
  require "mechanize"
  
  @scraping_agent = Mechanize::Mechanize.new

  desc "Scrape house data from daft.ie"
  task :all => :environment do
    Rake::Task['db:reset'].invoke
    scrape_all
    Rake::Task['db:populate'].invoke
  end

  desc "Scrape a single county based off it's ID"
  task :county, [:county_id] => :environment do |task, args|
    args.with_defaults(:county_id => 30) # fermanagh
    scrape_county args.county_id.to_s
  end
end

def scrape_all
  1.upto(32) do |county_id|
    scrape_county county_id
  end
end

def scrape_county county_id
  url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{county_id}&s%5Ba_id%5D%5B%5D=&s%5Broute_id%5D=&s%5Ba_id_transport%5D=0&s%5Baddress%5D=&s%5Btxt%5D=&s%5Bmnb%5D=&s%5Bmxb%5D=&s%5Bmnp%5D=&s%5Bmxp%5D=&s%5Bpt_id%5D=&s%5Bhouse_type%5D=&s%5Bsqmn%5D=&s%5Bsqmx%5D=&s%5Bmna%5D=&s%5Bmxa%5D=&s%5Bnpt_id%5D=&s%5Bdays_old%5D=&s%5Bnew%5D=&s%5Bagreed%5D=&search.x=34&search.y=20&search=Search+%BB&more=&tab=&search=1&s%5Bsearch_type%5D=sale&s%5Btransport%5D=&s%5Badvanced%5D=&s%5Bprice_per_room%5D=&fr=default"
  @scraping_agent.get(url)

  while(@scraping_agent.page.link_with(:text => "Next Page \u00BB")) do
    @scraping_agent.page.search(".content").each do |item|
#      I don't want to scrape houses with no prices ie. 'POA' or the like
      if item.at(".price").text[/[0-9,]+/]
        house = House.new
        title = item.at(".title a")
        house.title = title.text.strip
        house.description = item.at(".description").text
        house.image_url = item.at(".main_photo")[:src]
        house.daft_url = title[:href]
        house.price = item.at(".price").text[/[0-9,]+/].delete(',').to_i
        house.county_id = county_id.to_i - 1 # dafts counties are 1 indexed, mine are zero (array)

        house.save
      end
    end

    @scraping_agent.page.link_with(:text => "Next Page \u00BB").click
  end
end

