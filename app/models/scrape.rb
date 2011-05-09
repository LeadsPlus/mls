# make it auto scale the workers
# give ability to run though houses in the database, updating information from daft show page
# prevent it from inserting the same house from daft twice. Update instead
#   remember that people can update the information on a particular house, change it's price etc. This means that
#   just because a house is already recorded, I can't just skip over it on a subsequent scrape. It's details may have
#   changed and I would need to know about that
#     Perhaps a better way to do it is, if the daft_url exists, update it, else, create new.
#     but how do I deal with houses that have been sold. They need to be removed.
#  Possibly just make daft_url required unique in the database
# make a scrpae:all which adds all 32 counties to the queue

class Scrape
#  extend HerokuAutoScale
  
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

  def delete_county(daft_county_id = 30)
    House.delete_all("county = :county", { :county => county_names[daft_county_id.to_i - 1] })
  end
  
#  calling Scrape.new.perform is running this directly, not delayed
  def county(daft_county_id = 30)
#    note that if scraping fails, I could be left with no houses since I delete them all here
    delete_county daft_county_id

    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{daft_county_id}&s%5Ba_id%5D%5B%5D=&s%5Broute_id%5D=&s%5Ba_id_transport%5D=0&s%5Baddress%5D=&s%5Btxt%5D=&s%5Bmnb%5D=&s%5Bmxb%5D=&s%5Bmnp%5D=&s%5Bmxp%5D=&s%5Bpt_id%5D=&s%5Bhouse_type%5D=&s%5Bsqmn%5D=&s%5Bsqmx%5D=&s%5Bmna%5D=&s%5Bmxa%5D=&s%5Bnpt_id%5D=&s%5Bdays_old%5D=&s%5Bnew%5D=&s%5Bagreed%5D=&search.x=34&search.y=20&search=Search+%BB&more=&tab=&search=1&s%5Bsearch_type%5D=sale&s%5Btransport%5D=&s%5Badvanced%5D=&s%5Bprice_per_room%5D=&fr=default"
    puts "Scraping #{county_names[daft_county_id.to_i - 1]} via it's Daft county ID: #{daft_county_id}..."

    agent = Mechanize.new
    agent.get(url)

    while(agent.page.link_with(:text => "Next Page \u00BB")) do
      agent.page.search(".content").each do |search_result|
        store search_result, daft_county_id
      end

      agent.page.link_with(:text => "Next Page \u00BB").click
    end

    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASS']).set_workers(ENV['HEROKU_APP'], 1)
  end
  handle_asynchronously :county

  def store item, daft_county_id
# I don't want to scrape houses with no prices ie. 'POA' or the like
    title = item.at(".title a")
    if item.at(".price").text[/[0-9,]+/]
      House.create!({
        :title => title.text.strip,
        :description => item.at(".description").text.strip,
        :image_url => item.at(".main_photo")[:src],
        :daft_url => title[:href],
        :price => item.at(".price").text[/[0-9,]+/].delete(',').to_i,
        :county => county_names[daft_county_id.to_i - 1]
      })
      print '.'
    end
  end
end

