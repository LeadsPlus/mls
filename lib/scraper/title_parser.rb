module Scraper
  class TitleParser
    def initialize(title)
      @daft_title = title
    end

  #  this returns the index of the comma at the very end of town
#    TODO this doesn't work in Dub because the county can be "North Co. Dublin"
#    There's also a problem with Cork and other couties - Cork City Suburbs, West Cork
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
#          Rails.logger.debug "Checking if type: #{name}? Ans: #{type_portion.include? name}"
          return name if type_portion.include? name
        end
      end
  #    if there is no property type, just set it to nil
      Rails.logger.debug "Unknown Property type found: #{type_portion}" unless type_portion.nil?
      nil
    end
  end
end