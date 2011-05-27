# scrape the date entered
# split house type off the daft title

class DaftSearchResult
  attr_reader :county_id
  
  def initialize(html, daft_county_id)
    @html = html
    @county_id = daft_county_id
    @correct_town = nil
    @temp_rooms = nil
  end

  def has_price?
    @html.at(".price").text[/[0-9,]+/]
  end

#  this is messy, needs work
  def town
    unless @town
      Town.find_all_by_county_id(@county_id).each do |town|
#        this method is broken. See the rake house utilities parse_address
        @correct_town = town unless daft_title.index(town.name).nil?
      end
#      puts "Nil town found for #{house.daft_title}" if correct_town.nil?
    end
    @town ||= @correct_town # town will be a Town record
  end

#  some addresses are being stripped way too early.
#  578150 - "20 Lackaboy View, Enniskillen, Co. Fermanagh, BT74 4DY - Semi-Detached House" down to "20"
#  There is a town called Lack in the db
#  566795 - "133 Killadeas Road, Nr Ballycassidy, Enniskillen, Co. Fermanagh, BT94 2LZ - Detached House" down to "133"
#  here what's happening is that I'm matching the string way too early (Killadeas is a diff town)
#  solution is obv to match from the back
#  566776 - "Whitehill, Springfield, Enniskillen, Co. Fermanagh - Detached House" down to "Whitehill,"
#  same again here, Springfield is a different town
#  problem is because
  def address
    @address ||= daft_title[0, daft_title.rindex(town.name)]
  end

  def to_s
    "Title: #{daft_title}, Daft ID: #{daft_id}, Price: #{price}, Beds: #{rooms[0]}, Baths #{rooms[1]} \n
    Description: #{description}, \n Image: #{image} \n -------------------------------------"
  end

  def price
    @price ||= @html.at(".price").text[/\u20AC[0-9,]+/].gsub(/[\D]/, '').to_i
  end

  def image
    @image ||= @html.at(".main_photo")[:src]
  end

  def description
    @description ||= @html.at(".description").text.strip
  end

  def daft_id
    @daft_id ||= @html.at(".title a")[:href].match(/[0-9]+/) { |id| id[0].to_i }
  end

  def daft_title
    @daft_title ||= @html.at(".title a").text.strip
  end

#  This could be improved to get the acerage when we determine we're dealing with a site
#  This may not work properly now, I kinda messed with it a bit
#  this is very messy, needs work
  def rooms
    unless @rooms
      element = @html.at(".bedrooms")
      if element.nil?
        @temp_rooms = [0,0]
      else
        beds = element.text.match(/\d+ Be/)
        if !beds.nil?
          beds = beds[0].gsub(/\D+/, '').to_i
        else
          beds = 0
        end

        baths = element.text.match(/\d+ Ba/)
        if !baths.nil?
          baths = baths[0].gsub(/\D+/, '').to_i
        else
          baths = 0
        end
        @temp_rooms = [beds, baths]
      end
    end
    @rooms ||= @temp_rooms
  end
end