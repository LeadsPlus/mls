module Scraper
  class DaftHousePage
    def initialize(page, house)
      @html = page
      @house = house
    end

    def save_photos
      @html.search("div#pb_carousel ul li img").each do |img|
        unless img.nil?
          photo = Photo.find_or_initialize_by_url(img[:src])
          photo.update_attributes({
              url: img[:src],
              width: img[:width],
              height: img[:height],
              house_id: @house.id
          })
    #     I think I'm ok to just save the photo, if it's there
          photo.save
        end
      end
    end
  end
end
