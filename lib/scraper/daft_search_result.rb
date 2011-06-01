module Scraper
  class DaftSearchResult
    attr_reader :county

    def initialize(html, county)
      @html = html
      @county = county
      @temp_rooms = nil
    end

  #  returns nil if no digits in price selector, string otherwise
    def has_price?
      @html.at(".price").text[/[0-9,]+/]
    end

    def to_s
      "Title: #{daft_title}, Daft ID: #{daft_id}, Price: #{price}, Beds: #{rooms[0]}, Baths #{rooms[1]} \n
      Description: #{description}, \n Image: #{image} \n -------------------------------------"
    end

  #  returns an integer price. Only returns EUR price if given in sterling and euro
    def price
      @price ||= @html.at(".price").text[/\u20AC[0-9,]+/].gsub(/[\D]/, '').to_i
    end

  #  returns string url of the houses main thumbnail
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

  #  returns daft_title from the comma before county to end
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
  #    if this listing is for a new town, we pass in a placeholder for daft_id because we don't know it yet
  #    then the next time we run the town scraper, it will be filled in
      @town ||= Town.find_or_create_by_county_and_name(name: stripped_town, daft_id: nil, county: @county.name)
    end

  #  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
    def type_portion
      @type_portion ||= parse_type_portion
    end

  #  this returns the index of the " - " just after county else nil if doesn't exist
    def type_index
      @type_index ||= county_onwards.rindex(/ - /)
    end

  #  returns the portion of daft_title from the " - " just after county else nil if " - " doesn't exist
    def parse_type_portion
      unless type_index.nil?
        county_onwards[type_index, county_onwards.length]
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
      unless type_portion.nil?
        PropertyType.each_name do |name|
          return name if type_portion.include? name
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
  #  this is very messy, needs work
    def rooms
      unless @rooms
        element = @html.at(".bedrooms")
        if element.nil?
  #        this should probably be [nil,nil]
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

    def save
      if has_price?
        house = House.find_or_initialize_by_daft_id(daft_id)
  #     This automatically only updates fields which have changed
        house.update_attributes({
          daft_title: daft_title,
          description: description,
          image_url: image,
          price: price,
          bedrooms: rooms[0],
          bathrooms: rooms[1],
          address: address,
          property_type: type
        })
        house.county = @county
        house.town = town
        house.save!
      end
    end
  end
end