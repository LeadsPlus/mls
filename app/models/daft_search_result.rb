class DaftSearchResult
  attr_reader :daft_title, :daft_id, :price, :image, :description, :rooms
  
  def initialize(html)
    @html = html
  end

  def extract
    @daft_title = extract_title
    @daft_id = extract_daft_id
    @price = extract_price
    @image = extract_image_src
    @description = extract_description
    @rooms = extract_rooms
  end

  def has_price?
    @html.at(".price").text[/[0-9,]+/]
  end

  def to_s
    "Title: #{@daft_title}, Daft ID: #{@daft_id}, Price: #{price}, Beds: #{@rooms[0]}, Baths #{@rooms[1]} \n
    Description: #{@description}, \n Image: #{@image} \n -------------------------------------"
  end

  def extract_price
    @html.at(".price").text[/\u20AC[0-9,]+/].gsub(/[\D]/, '').to_i
  end

  def extract_image_src
    @html.at(".main_photo")[:src]
  end

  def extract_description
    @html.at(".description").text.strip
  end

  def extract_daft_id
    @html.at(".title a")[:href].match(/[0-9]+/) { |id| id[0].to_i }
  end

  def extract_title
    @html.at(".title a").text.strip
  end

#  This could be improved to get the acerage when we determine we're dealing with a site
#    some results don't have beds and baths listed
#    Sites often have the number of acres in the .bedrooms tag
  def extract_rooms
    element = @html.at(".bedrooms")
    unless element.nil?
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
      return [beds, baths]
    end
    [0,0]
  end
end