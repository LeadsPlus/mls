class Scrape
#  calling Scrape.new.perform is running this directly, not delayed
  def perform(county_id = 30)
    county_names = %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down].freeze

    url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{county_id}&s%5Ba_id%5D%5B%5D=&s%5Broute_id%5D=&s%5Ba_id_transport%5D=0&s%5Baddress%5D=&s%5Btxt%5D=&s%5Bmnb%5D=&s%5Bmxb%5D=&s%5Bmnp%5D=&s%5Bmxp%5D=&s%5Bpt_id%5D=&s%5Bhouse_type%5D=&s%5Bsqmn%5D=&s%5Bsqmx%5D=&s%5Bmna%5D=&s%5Bmxa%5D=&s%5Bnpt_id%5D=&s%5Bdays_old%5D=&s%5Bnew%5D=&s%5Bagreed%5D=&search.x=34&search.y=20&search=Search+%BB&more=&tab=&search=1&s%5Bsearch_type%5D=sale&s%5Btransport%5D=&s%5Badvanced%5D=&s%5Bprice_per_room%5D=&fr=default"
    puts "Scraping #{county_names[county_id.to_i - 1]} via it's Daft county ID: #{county_id}..."

    agent = Mechanize.new
    agent.get(url)
#  #  while the page has a 'next page' link
    if agent.page.link_with(:text => "Next Page \u00BB")
      puts "link text found using unicode escape"
    elsif agent.page.link_with(:text => "Next Page »")
      puts "link text found using literal"
    end
#    while(agent.page.link_with(:text => "Next Page \u00BB")) do
#      puts page.at("title")
#      agent.page.search(".content").each do |item|
#        store item
#      end
#
#      agent.page.link_with(:text => "Next Page \u00BB").click
#    end
  end
end

def store item
# I don't want to scrape houses with no prices ie. 'POA' or the like
  title = item.at(".title a")
  puts title.text.strip
  if item.at(".price").text[/[0-9,]+/]
    House.create!({
      :title => title.text.strip,
      :description => item.at(".description").text.strip,
      :image_url => item.at(".main_photo")[:src],
      :daft_url => title[:href],
      :price => item.at(".price").text[/[0-9,]+/].delete(',').to_i,
      :county => county_names[county_id.to_i - 1]
    })
  end
end