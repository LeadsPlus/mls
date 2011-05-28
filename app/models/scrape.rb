#  I also need to make a cron for doing all these tasks
# examples of what can happen when a house is sold: /Users/davidtuite/Dropbox/MLS stuff
# I can get the Lat/Long of the gaff also from a google maps initialization script on the page

# It seems that Daft automatically updates sterling prices in accordance with the exchange rate.
# This also changes the value of the "Date Entered" field

# this all needs to be updated to take advantage of the new counties model

# ok problem, because I'm indexing off COUNTIES but trying to link to the counties model, the index's are off
# because the counties model doesn't go back to 1 when I delete all the counties
class Scrape
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
    agent.get(url)

#    while I'm here, can get the towns. Remember towns need to be deleted first
    Town.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.towns_id_seq', 1, false)"
    create_towns_off agent.page, county

    while(agent.page.link_with(:text => "Next Page \u00BB")) do
      agent.page.search(".content").each do |house_item|
#        I should build the DaftSearchResult here and pass it into the store listing method as the only param
#        Or, build my own page object and store daft_county_id as instance var then pass that around??
#        Or, move the county scraping methods into the county model???

        result = DaftSearchResult.new(house_item, county)
        store_listing result
      end

      agent.page.link_with(:text => "Next Page \u00BB").click
    end
  end
#  handle_asynchronously :county

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
        Town.create!(name: text, daft_id: value, county_id: county.daft_id)
      end
    end
  end
end
