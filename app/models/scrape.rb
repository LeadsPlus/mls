# give ability to run though houses in the database, updating information from daft show page
# prevent it from inserting the same house from daft twice. Update instead
#   remember that people can update the information on a particular house, change it's price etc. This means that
#   just because a house is already recorded, I can't just skip over it on a subsequent scrape. It's details may have
#   changed and I would need to know about that

#  if House.find_by_daft_id daft_id
#    update details with info from the scrape
#  else
#   create a new house
#  end

# add a daft_id to the table. Daft_id is an integer see this: http://api.daft.ie/examples/php5/#media
# figure out how to parse it from the url
# delete the daft_url column and construct them from the daft_id instead
# find by daft id

#  Removal of houses from my DB will have to run the other way
#  House.each do |house|
#    try to access the daft_url for the house
#    if able, grand
#    else remove the house from the DB
#  end

#  Possibly just make daft_url required unique in the database
#  I also need to make a cron for doing all these tasks
# I need a way to deal with NI prices like this: "£185,000 (€212,913)"

# examples of what can happen when a house is sold: /Users/davidtuite/Dropbox/MLS stuff

# all images are loaded with the page. hrefs are listed in a div#photo_browser >> #pb_carousel at the bottom
# Houses with no photos have no carousel
# I can get the Lat/Long of the gaff also from a google maps initialization script on the page



class Scrape
  def all
    1.upto(32) do |daft_county_id|
      county daft_county_id
    end
  end

  def visit_all_counties
    1.upto(32) do |daft_county_id|
      visit_houses_in_county daft_county_id
    end
  end

  def delete_houses_in_county(daft_county_id = 30)
    House.delete_all("county = '#{COUNTIES[daft_county_id.to_i - 1]}'")
  end

  def visit_houses_in_county(daft_county_id = 30)
    agent = Mechanize.new
    puts "Visiting all houses in #{COUNTIES[daft_county_id.to_i - 1]}..."

    House.where(:county => COUNTIES[daft_county_id.to_i - 1]).find_each() do |house|
#      puts "visiting house with ID: #{house.daft_id}"
      store_visit house, agent
    end
  end
  handle_asynchronously :visit_houses_in_county

  def visit_houses_starting_from house_id
    agent = Mechanize.new

    House.find_each(:start => house_id) do |house|
      store_visit house, agent
    end
  end

#  It's possibly a bit silly that I'm running through search results and storing prices etc..
#  Then a few mins later visiting each house and updating the price
#  If I can prove that the :county method will actually update houses that have changed from the search results
#  then I should probably remove "price =" and other duplicates from this method
  def store_visit house, agent
#    if we get returned a 404 of the form Scrape#visit_houses_in_county_without_delay failed with Mechanize::ResponseCodeError: 404 => Net::HTTPNotFound - 0 failed attempts
#    that means we got the daft page.. "property has either been sold or removed from daft...."
    begin
      agent.get house.daft_url
    rescue Mechanize::ResponseCodeError
      house.destroy
      return
    end

#    why is it a big deal if I set the attribute to the same value it already contained?
#    I don't this will cause any problems tbh?
#    Only point would be if it was faster to only update if different?
    property_type = agent.page.at("#smi_prop_type").text
    house.property_type = property_type unless house.property_type == property_type

    address = agent.page.at("h1").text
    house.address = address unless house.address == address

#      puts "#{address} \n #{property_type}"

    description = agent.page.at("#smi_description").text
    date_string = description.match(/\d+\/\d+\/\d+/)[0]
#      I'm pretty sure the date thinger isn't working. A lot of the dates are the same. Pretty suspiscious.
    daft_date_created = Date.strptime(date_string, "%d/%m/%Y" )
#    puts "Daft_url: #{house.daft_url} Date: #{date_string}. Date Obj: #{daft_date_created}"

    house.daft_date_created = daft_date_created if house.daft_date_created.blank?

#      I cant just add a bunch of photos to the table, need to check if they're unique first
#    Will throw an ActiveRecord::RecordInvalid error if already exists.
      agent.page.search("div#pb_carousel ul li img").each do |img|
        photo = Photo.new({
            :url => img[:src],
            :width => img[:width],
            :height => img[:height]
        })
        photo.house = house
#        I think I'm ok to just save the photo, if it's there
        photo.save
      end

    house.save!
  end

#  This method will pull up all search results in a particular county and cycle over each result
#  If the result corresponds to an existing house record, the record will be updated ??
#  if the result is new, a House will be built and saved with minimal information
  def county(daft_county_id = 30)

    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{daft_county_id}&s%5Ba_id%5D%5B%5D=&s%5Broute_id%5D=&s%5Ba_id_transport%5D=0&s%5Baddress%5D=&s%5Btxt%5D=&s%5Bmnb%5D=&s%5Bmxb%5D=&s%5Bmnp%5D=&s%5Bmxp%5D=&s%5Bpt_id%5D=&s%5Bhouse_type%5D=&s%5Bsqmn%5D=&s%5Bsqmx%5D=&s%5Bmna%5D=&s%5Bmxa%5D=&s%5Bnpt_id%5D=&s%5Bdays_old%5D=&s%5Bnew%5D=&s%5Bagreed%5D=&search.x=34&search.y=20&search=Search+%BB&more=&tab=&search=1&s%5Bsearch_type%5D=sale&s%5Btransport%5D=&s%5Badvanced%5D=&s%5Bprice_per_room%5D=&fr=default"
    puts "Scraping #{COUNTIES[daft_county_id.to_i - 1]} via it's Daft county ID: #{daft_county_id}..."

    agent = Mechanize.new
    agent.get(url)

    while(agent.page.link_with(:text => "Next Page \u00BB")) do
      agent.page.search(".content").each do |search_result|
        title = search_result.at(".title a")
        daft_id = title[:href].match(/[0-9]+/) { |id| id[0].to_i }

        if search_result.at(".price").text[/[0-9,]+/]
#          some results don't have beds and baths listed
#          Sites often have the number of acres in the .bedrooms tag
          if search_result.at(".bedrooms")
            beds = search_result.at(".bedrooms").text.match(/[0-9]+ Bed/)[0]
            baths = search_result.at(".bedrooms").text.match(/[0-9]+ Bath/)[0]
          else
            beds = 0
            baths = 0
          end

          House.find_or_create_by_daft_id(daft_id) do |house|
            house.daft_title = title.text.strip
            house.description = search_result.at(".description").text.strip,
            house.image_url = search_result.at(".main_photo")[:src],
            house.price = search_result.at(".price").text[/\u20AC[0-9,]+/].gsub(/[\D]/, '').to_i,
            house.county = COUNTIES[daft_county_id.to_i - 1]
            house.bedrooms = beds.to_i,
            house.bathrooms = baths.to_i
          end
        end
      end

      agent.page.link_with(:text => "Next Page \u00BB").click
    end
  end
  handle_asynchronously :county # doesn't seem to work with HireFire

end
