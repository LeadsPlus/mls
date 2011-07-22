module Scraper
  class DaftSearchResult
    attr_reader :county
    NI_COUNTIES = ['Down', 'Derry', 'Antrim', 'Armagh', 'Fermanagh', 'Tyrone']

    def initialize(html, county)
      @html = html
      @county = county
      @title_parser = title_parser
    end

    # TODO For some reason the NiTitleParser is being used for cork
    def title_parser
      unless @title_parser
        if @county.name == 'Dublin'
          Rails.logger.debug "Using the Dublin Parser"
          @title_parser = Scraper::DublinTitleParser.new(daft_title, @county)
        elsif
          Rails.logger.debug "Using the NI Parser"
          @title_parser = Scraper::NiTitleParser.new(daft_title, @county) if NI_COUNTIES.include?(@county.name)
        else
          Rails.logger.debug "Using the Normal Parser"
          @title_parser = Scraper::TitleParser.new(daft_title, @county)
        end
      end
      @title_parser
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
      return unless has_price?
      @price ||= price_text.gsub(/[\D]/, '').to_i
    end

    def price_text
      @price_text ||= @html.at(".price").text[/\u20AC[0-9,]+/]
    end

  #  returns string url of the houses main thumbnail
    def image
      @image ||= @html.at(".main_photo")[:src]
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
    def rooms
      unless @rooms
        element = @html.at('.bedrooms')
        if element.nil?
          @rooms = [0,0]
        else
          @rooms = [parse_beds(element),parse_baths(element)]
        end
      end
      @rooms
    end

    def parse_beds element
      beds = element.text.match /\d+ Be/
      return 0 if beds.nil?
      beds[0].gsub(/\D+/, '').to_i
    end

    def parse_baths element
      baths = element.text.match /\d+ Ba/
      return 0 if baths.nil?
      baths[0].gsub(/\D+/, '').to_i
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
          address: @title_parser.address,
          region_name: @title_parser.region,
          last_scrape: 1
        })
        house.county = @county
        house.town = @title_parser.town
        house.property_type = @title_parser.type
        house.save!
      end
    end
  end
end
