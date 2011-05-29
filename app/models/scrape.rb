#  I also need to make a cron for doing all these tasks
# examples of what can happen when a house is sold: /Users/davidtuite/Dropbox/MLS stuff
# I can get the Lat/Long of the gaff also from a google maps initialization script on the page

# It seems that Daft automatically updates sterling prices in accordance with the exchange rate.
# This also changes the value of the "Date Entered" field

# this all needs to be updated to take advantage of the new counties model
# most of these methods should be class methods I think

# ok problem, because I'm indexing off COUNTIES but trying to link to the counties model, the index's are off
# because the counties model doesn't go back to 1 when I delete all the counties

#user agent aliases
#"Windows IE 6"=>"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
#"Windows IE 7"=>"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
#"Windows Mozilla"=>"Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6",
#"Mac Safari"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10",
#"Mac FireFox"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
#"Mac Mozilla"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401",
#"Linux Mozilla"=>"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624",
#"Linux Firefox"=>"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1",
#"Linux Konqueror"=>"Mozilla/5.0 (compatible; Konqueror/3; Linux)",
#"iPhone"=>"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3",
#"Mechanize"=>"WWW-Mechanize/1.0.0 (http://rubyforge.org/projects/mechanize/)"}

class Scrape
  AGENT_ALIASES = ["Windows IE 6", "Windows IE 7", "Windows Mozilla", "Mac Safari", "Mac FireFox", "Mac Mozilla"]


  
  def visit_houses_in_county(daft_county_id = 30)
    agent = Mechanize.new
    puts "Visiting all houses in #{COUNTIES[daft_county_id.to_i - 1]}..."

    House.where(:county => COUNTIES[daft_county_id.to_i - 1]).find_each() do |house|
#      puts "visiting house with ID: #{house.daft_id}"
      store_visit house, agent
    end
  end
  handle_asynchronously :visit_houses_in_county

  def store_visit(house, agent)
#    if we get returned a 404 of the form Scrape#visit_houses_in_county_without_delay failed with Mechanize::ResponseCodeError: 404 => Net::HTTPNotFound - 0 failed attempts
#    that means we got the daft page.. "property has either been sold or removed from daft...."
    begin
      agent.get(house.daft_url)
    rescue Mechanize::ResponseCodeError
      house.destroy
      return
    end

    daft_house = DaftHousePage.new(agent.page, house)
    daft_house.update_house!
  end

#  This method will pull up all search results in a particular county and cycle over each result
#  If the result corresponds to an existing house record, the record will be updated ??
#  if the result is new, a House will be built and saved with minimal information
  def county(county)
    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{county.daft_id}&search=1&submit.x=23&submit.y=11"
    puts "Scraping #{county.name} via it's Daft county ID: #{county.daft_id}..."

    agent = Mechanize.new
#    agent.user_agent_alias = "Mac Safari"
    agent.get(url)

#    while I'm here, can get the towns. Remember towns need to be deleted first
    Town.reset
    create_towns_off agent.page, county

    while(agent.page.link_with(:text => "Next Page \u00BB")) do
      agent.page.search(".content").each do |house_item|
#        I should build the DaftSearchResult here and pass it into the store listing method as the only param
#        Or, build my own page object and store daft_county_id as instance var then pass that around??
#        Or, move the county scraping methods into the county model???

        result = DaftSearchResult.new(house_item, county)
        store_listing result
      end

#      sleep for one second so we don't kill daft
      sleep 1
      agent.page.link_with(:text => "Next Page \u00BB").click
    end
  end
  handle_asynchronously :county

  def store_listing result
    if result.has_price?
      house = House.find_or_initialize_by_daft_id(result.daft_id)
#          This automatically only updates fields which have changed
      house.update_attributes({
        daft_title: result.daft_title,
        description: result.description,
        image_url: result.image,
        price: result.price,
        bedrooms: result.rooms[0],
        bathrooms: result.rooms[1],
        address: result.address,
        property_type: result.type
      })
      house.county = result.county
      house.town = result.town
      house.save!
    end
  end

  def visit_houses_starting_from house_id
    agent = Mechanize.new

    House.find_each(:start => house_id) do |house|
      store_visit house, agent
    end
  end
  handle_asynchronously :visit_houses_starting_from

  def all
    County.all.each do |county|
      county county
    end
  end

  def visit_all_counties
    1.upto(32) do |daft_county_id|
      visit_houses_in_county daft_county_id
    end
  end

  def delete_houses_in_county(county_name)
    House.delete_all("county = '#{county_name}'")
  end

#  this should be a generic visit all counties method. Pass a block
  def towns
    County.all.each do |county|
      towns_in_county county
    end
  end

#  this should be a generic visit county method. Then I can pass it a block depending on what I want
#  to do while I'm there
  def towns_in_county(county)
    agent = Mechanize.new
    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{county.daft_id}&search=1&submit.x=23&submit.y=11"
    agent.get(url)

    puts "Scraping the locations in county: #{county.name}"
    create_towns_off agent.page, county
  end

  def create_towns_off page, county
    page.search("#a_id option").each do |option|
      value = option[:value]
      text = option.text.gsub(/(- | -)/, "").gsub(/ \(.+\)/, "")

      unless text =~ /(-+|Dublin Commuter)/ || value.blank?
        town = Town.new(name: text, daft_id: value)
        town.county = county
        town.save
      end
    end
  end
end
