class DaftHousePage
  def initialize(page, house)
    @html = page
    @house = house
  end

  def extract
    @property_type = extract_prop_type
    @address = extract_address
    @description = extract_description
    @daft_date_entered = extract_date
  end

  def update_house!
    extract
#    These are only updated if different
    @house.update_attributes({
        :property_type => @property_type,
        :address => @address,
        :daft_date_created => @daft_date_entered,
    })
    save_photos
    @house.save
  end

  private

    def extract_prop_type
      @html.at("#smi_prop_type").text
    end

    def extract_address
      @html.at("h1").text
    end

    def extract_description
      @html.at("#smi_description").text
    end

#    "Date Entered" changes whenever details on the post are changed
#     It doesn't seem to have any relevance to when the house was first registered with Daft
    def extract_date
      date_string = @description.match(/\d+\/\d+\/\d+/)[0]
      Date.strptime(date_string, "%d/%m/%Y" )
    end

    def save_photos
      @html.search("div#pb_carousel ul li img").each do |img|
        photo = Photo.find_or_initialize_by_url(img[:src])
        photo.update_attributes({
            :url => img[:src],
            :width => img[:width],
            :height => img[:height],
            :house_id => @house.id
        })
  #     I think I'm ok to just save the photo, if it's there
        photo.save!
      end
    end
end