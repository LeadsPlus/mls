# new flow:
#   get the region and type the same way.
#   if the second last element in location array is a recognised town -> set it.
#     set everything else to be address.
#   otherwise, check if it's an area code.
#     if so, store the area code and check for the town in the third last element
#     if not, assume only region and address
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
      Rails.logger.debug "Location: #{@daft_title.slice(0, split_index)}"
      @location ||= @daft_title.slice(0, split_index)
    end

#    returns an empty string if there is no type
    def split_location
      Rails.logger.debug "Split Location: #{location.split ', '}"
      @split_location ||= location.split ', '
    end

    def region
      Rails.logger.debug "getting the region: #{split_location.last}"
      @region ||= split_location.last
    end

    def town
      Rails.logger.debug "Found town: #{Town.find_by_name_and_county(split_location[-2], @county.name)}"
      @town ||= Town.find_by_name_and_county(split_location[-2], @county.name)
    end

    def get_address
#      there is always a region and a town
      split_location[0, split_location.length - 2]
    end

#    address will be an empty string if all we're given is a town, (optional area_code) and region
    def address
      unless @address
        address_array = get_address
        @address = address_array.join ', '
      end
      @address
    end

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
#      if there is no property type, just set it to nil
      nil
    end

    def type
      @type ||= parse_type
    end

  end

  class DublinTitleParser < TitleParser
#    this is all wrong IMO. Can't think how to fix it yet
    def town
      Rails.logger.debug "Accessing the town"
      unless @town
        if town_based
          Rails.logger.debug "Is a town based Title"
          @town = Town.find_by_name_and_county(split_location[-2], @county.name)
        else
          Rails.logger.debug "Not a town based title"
          @town = Town.find_by_name_and_county(split_location[-3], @county.name)
          Rails.logger.debug "Found town: #{Town.find_by_name_and_county(split_location[-3], @county.name).name}"
        end
      end
      @town
    end

    def area_code
      unless @area_code
        if !town_based
          @area_code = split_location[-2]
        else
          @area_code = nil
        end
      end
      @area_code
    end

    def town_based
      @town_based ||= Town.find_by_name_and_county(split_location[-2], @county.name)
    end

#    will return an index integer or nil
    def is_area_code?(code)
      code =~ /Dublin \d/
    end

    def get_address
#      there is always a town since it's created if it doesn't exist
      return split_location[0, split_location.length - 2] if town_based
      split_location[0, split_location.length - 3]
    end
  end
end