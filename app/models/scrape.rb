#  I also need to make a cron for doing all these tasks
# examples of what can happen when a house is sold: /Users/davidtuite/Dropbox/MLS stuff
# I can get the Lat/Long of the gaff also from a google maps initialization script on the page

# It seems that Daft automatically updates sterling prices in accordance with the exchange rate.
# This also changes the value of the "Date Entered" field

# this all needs to be updated to take advantage of the new counties model
# most of these methods should be class methods I think

# ok problem, because I'm indexing off COUNTIES but trying to link to the counties model, the index's are off
# because the counties model doesn't go back to 1 when I delete all the counties

# if I keep track of every daft_id I find in a particular run, I can delete unlisted houses when finished!??
# give every house a scrape_id param defaulting to one, if a subsequent scrape finds a house again,
# increment the scrape_id. Then run through the houses table deleting houses where scrape_id != max scrape_id

class Scrape
  attr_accessor :agent
  AGENT_ALIASES = ["Windows IE 6", "Windows IE 7", "Windows Mozilla", "Mac Safari",
                   "Mac FireFox", "Mac Mozilla"]

  def initialize
    add_modern_aliases
    @agent = Mechanize.new
  end

#  This method will pull up all search results in a particular county and cycle over each result
#  If the result corresponds to an existing house record, the record will be updated
#  if the result is new, a House will be built and saved with minimal information
  def refresh_listings_in(*counties)
    counties.each do |county|
      @county = county
      refresh_listings_in_the_county
    end
  end

  def refresh_towns_in( *counties )
    counties.each do |county|
      @county = county
      url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
      change_agent_alias
      @agent.get(url)
      puts "Scraping the towns in: #{@county.name}"
      scrape_town_options
      sleep 1
    end
  end
  handle_asynchronously :refresh_towns_in

  def visit_houses_in(*counties)
    counties.each do |county|
      @county = county
      visit_houses_in_the_county
    end
  end

  private

#  this should take approx 30 mins per 10k houses
  def refresh_listings_in_the_county
    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
    puts "Scraping #{@county.name} via it's Daft county ID: #{@county.daft_id}..."

    change_agent_alias
    @agent.get(url)

    while next_page_link do
      scrape_house_listings
#      sleep for a second so we don't kill daft
      sleep 1
      change_agent_alias
      next_page_link.click
    end
  end
  handle_asynchronously :refresh_listings_in_the_county

  def scrape_town_options
    @agent.page.search("#a_id option").each do |option|
      value = option[:value]
      text = option.text.gsub(/(- | -)/, "").gsub(/ \(.+\)/, "")

      unless text =~ /(-+|Dublin Commuter)/ || value.blank?
        Town.create_or_update_by_county_and_name(@county, { name: text, daft_id: value })
      end
    end
  end

  def visit_houses_in_the_county
    puts "Visiting all houses in #{@county.name}..."

    House.where(:county_id => @county.id).find_each() do |house|
#      puts "visiting house with ID: #{house.daft_id}"
      store_visit house
    end
  end
  handle_asynchronously :visit_houses_in_the_county

  def store_visit(house)
    change_agent_alias
#    if we get returned a 404 of the form Scrape#visit_houses_in_county_without_delay failed with Mechanize::ResponseCodeError: 404 => Net::HTTPNotFound - 0 failed attempts
#    that means we got the daft page.. "property has either been sold or removed from daft...."
    begin
      @agent.get(house.daft_url)
    rescue Mechanize::ResponseCodeError
      house.destroy
      return
    end

    DaftHousePage.new(@agent.page, house).save_photos
    sleep 1
  end

  def add_modern_aliases
    add_alias "Win7 Safari3","Mozilla/5.0 (Windows; U; Windows NT 6.1; da) AppleWebKit/522.15.5 (KHTML, like Gecko) Version/3.0.3 Safari/522.15.5"
    add_alias "WinXP Safari3", "Mozilla/5.0 (Windows; U; Windows NT 5.1; id) AppleWebKit/522.11.3 (KHTML, like Gecko) Version/3.0 Safari/522.11.3"
    add_alias "Mac Safari4", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_1; zh-CN) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/4.0.2 Safari/530.19"
  end

  def add_alias name, header
    Mechanize::AGENT_ALIASES[name] = header
#    update the local list of available aliases
    AGENT_ALIASES << name
  end

  def change_agent_alias
    @agent.user_agent_alias = AGENT_ALIASES[rand(AGENT_ALIASES.size)]
  end

  def next_page_link
    @agent.page.link_with(:text => "Next Page \u00BB")
  end

  def scrape_house_listings
    @agent.page.search(".content").each do |listing|
      DaftSearchResult.new(listing, @county).save
    end
  end
end
