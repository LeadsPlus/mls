class DaftSearchResult
  attr_reader :county
  
  def initialize(html, county)
    @html = html
    @county = county
    @correct_town = nil
    @temp_rooms = nil
  end

  def has_price?
    @html.at(".price").text[/[0-9,]+/]
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

#  this returns the index of the comma at the very end of town
  def county_index
    @county_index = daft_title.rindex(/, Co\./)
  end

#  returns the daft_title up as far as the comma at the very end of the town name
  def title_upto_county
#    this will try to strip from 0 to nil if regex misses!?
    @title_upto_county ||= daft_title[0, county_index]
  end

  def county_onwards
    @county_onwards ||= daft_title[county_index, daft_title.length]
  end

#  this returns the index of the comma at the very end of address
  def town_index
#    this only matches one letter if you remove the " " prefix
    @town_index ||= title_upto_county.rindex(/, \w+/)
  end

#  returns the string name of the town this house belongs to
  def stripped_town
    @stripped_town ||= title_upto_county[town_index, title_upto_county.length].gsub(/, /, '')
  end

#  returns the portion of the daft_title which is the freeform address
  def address
    @address ||= title_upto_county[0, town_index]
  end

#  returns the ActiveRecord Town which this house belongs to
  def town
    @town ||= county.towns.find_by_name(stripped_town)
  end

#  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
  def property_type_portion
    @property_type_portion ||= parse_property_type_portion
  end

#  this returns the index of the " - " just after county else nil if doesn't exist
  def property_type_index
    @property_type_index ||= county_onwards.rindex(/ - /)
  end

#  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
  def parse_property_type_portion
    unless property_type_index.nil?
      county_onwards[property_type_index, county_onwards.length]
    end
  end

#  returns the property type
  def type
    @type ||= parse_type
  end

#  finds the corresponding house type in the HOUSE_TYPES array
#  this works because HOUSE_TYPES is set up in such a way that no type includes another as a substring
#  some properties have no type
#  some properties have " - " in the freeform address part, hence matching this (only) cannot be relied on
  def parse_type
    puts "Daft_id: #{daft_id}, Type string: #{property_type_portion}"
    unless property_type_portion.nil?
      HOUSE_TYPES.each do |type|
        return type if property_type_portion.include? type
      end
    end
#    returns nil if we make it to here
  end

#  returns the description text
  def description
    @description ||= @html.at(".description").text.strip
  end

#  returns the daft id of the poperty as integer
  def daft_id
    @daft_id ||= @html.at(".title a")[:href].match(/[0-9]+/) { |id| id[0].to_i }
  end

#  returns the daft result listings title
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