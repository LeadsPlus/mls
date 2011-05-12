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
  

class Scrape
  def county_names
    @county_names = %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down].freeze
  end

  def all
    1.upto(32) do |daft_county_id|
      county daft_county_id
    end
  end

  def delete_houses_in_county(daft_county_id = 30)
    House.delete_all("county = '#{county_names[daft_county_id.to_i - 1]}'")
  end
  
  def county(daft_county_id = 30)
#    note that if scraping fails, I could be left with no houses since I delete them all here
    delete_houses_in_county daft_county_id

    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{daft_county_id}&s%5Ba_id%5D%5B%5D=&s%5Broute_id%5D=&s%5Ba_id_transport%5D=0&s%5Baddress%5D=&s%5Btxt%5D=&s%5Bmnb%5D=&s%5Bmxb%5D=&s%5Bmnp%5D=&s%5Bmxp%5D=&s%5Bpt_id%5D=&s%5Bhouse_type%5D=&s%5Bsqmn%5D=&s%5Bsqmx%5D=&s%5Bmna%5D=&s%5Bmxa%5D=&s%5Bnpt_id%5D=&s%5Bdays_old%5D=&s%5Bnew%5D=&s%5Bagreed%5D=&search.x=34&search.y=20&search=Search+%BB&more=&tab=&search=1&s%5Bsearch_type%5D=sale&s%5Btransport%5D=&s%5Badvanced%5D=&s%5Bprice_per_room%5D=&fr=default"
    puts "Scraping #{county_names[daft_county_id.to_i - 1]} via it's Daft county ID: #{daft_county_id}..."

    agent = Mechanize.new
    agent.get(url)

    while(agent.page.link_with(:text => "Next Page \u00BB")) do
      agent.page.search(".content").each do |search_result|
        daft_id = search_result.at(".title a")[:href].match(/[0-9]+/) { |id| id[0].to_i }
        house = House.find_by_daft_id(daft_id)
        if house
          update search_result, daft_county_id, house
        else
          store search_result, daft_county_id
        end
      end

      agent.page.link_with(:text => "Next Page \u00BB").click
    end
  end
  handle_asynchronously :county # doesn't seem to work with HireFire

  def update item, daft_county_id, house
    title = item.at(".title a")
    if item.at(".price").text[/[0-9,]+/]
#      it's probably just as fast to update everything as it is to check if things changed yet
      house.update_attributes({
        :title => title.text.strip,
        :description => item.at(".description").text.strip,
        :image_url => item.at(".main_photo")[:src],
        :daft_id => title[:href].match(/[0-9]+/) { |id| id[0].to_i },
        :price => item.at(".price").text[/[0-9,]+/].delete(',').to_i,
        :county => county_names[daft_county_id.to_i - 1]
      })
      print '.'
    end
  end

  def store item, daft_county_id
# I don't want to scrape houses with no prices ie. 'POA' or the like
    title = item.at(".title a")
    if item.at(".price").text[/[0-9,]+/]
      House.create({
        :title => title.text.strip,
        :description => item.at(".description").text.strip,
        :image_url => item.at(".main_photo")[:src],
        :daft_id => title[:href].match(/[0-9]+/) { |id| id[0].to_i },
        :price => item.at(".price").text[/[0-9,]+/].delete(',').to_i,
        :county => county_names[daft_county_id.to_i - 1]
      })
      print '.'
    end
  end
end

