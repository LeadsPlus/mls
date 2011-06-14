module Scraper
  class TitleParser
    def initialize(title, county)
      @daft_title = title
      @county = county
    end

#    I could start at the rightmost ' - ' and work backwards. Semi-D has no spaces in it's hyphen
#    assumption: None of the property type identifiers ever have a ' - ' in them.
#    assumption: Even when the property type is not supplied, the hyphen is still there

    def split_index
      @daft_title.rindex(/ - /)
    end

    def location
      @location ||= @daft_title.slice(0, split_index)
    end

#    returns an empty string if there is no type
    def type_string
      @type_string ||= @daft_title.slice(split_index + 3, @daft_title.length)
    end

    #  finds the corresponding house type in the HOUSE_TYPES array
    #  this works because HOUSE_TYPES is set up in such a way that no type includes another as a substring
    #  some properties have no type
    #  some properties have " - " in the freeform address part, hence matching this (only) cannot be relied on
    def parse_type
      unless type_string.nil?
        PropertyType.each_name do |name|
#          Rails.logger.debug "Checking if type: #{name}? Ans: #{type_portion.include? name}"
          return name if type_string.include? name
        end
      end
      #    if there is no property type, just set it to nil
      nil
    end

    def type
      @type ||= parse_type
    end

    def split_location
      @split_location ||= location.split ', '
    end

    def region
      @region ||= split_location.last
    end

    def town_string
      return nil unless split_location.length > 1
      @town_string ||= split_location[-2]
    end

#   returns the ActiveRecord Town which this house belongs to
    def town
#     if this listing is for a new town, we pass in a placeholder for daft_id because we don't know it yet
#     then the next time we run the town scraper, it will be filled in
      @town ||= Town.find_or_create_by_county_and_name(name: town_string, daft_id: nil, county: @county.name)
    end

    def get_address
#      there is always a region and a town
      split_location[0, split_location.length - 2]
    end

#    address will be an empty string if all we're given is a town, (optional area_code) and region
    def address
      unless @address
#        if there's a town,
        address_array = get_address
        @address = address_array.join ', '
      end
      @address
    end
  end

  class DublinTitleParser < TitleParser
    def town_string
      unless @town
        if area_code?
#         one r-element is region, second is area code. Has to be 3 long for there to be a town
          return nil unless split_location.length > 2
          @town = split_location[-3]
        else
          return nil unless split_location.length > 1
#         if there's no area code, the town is found in the element previous to region info
          @town = split_location[-2]
        end
      end
      @town
    end

    def area_code?
#      there is no area code info if split_location is only one element long
      return nil if split_location.length == 1
#      return true if the second last element (after region) looks like an area code
#      remember that some area codes are like -> 'Dublin 6w'
      true if split_location[-2].is_a? String and split_location[-2] =~ /Dublin \d/
    end

    def area_code
      return nil unless area_code?
      @area_code ||= split_location[-2]
    end

    def get_address
#      there is always a town since it's created if it doesn't exist
      return split_location[0, split_location.length - 2] if !area_code?
      split_location[0, split_location.length - 3] if area_code?
    end
  end
end