module Scraper
  class HousesScraper < Scrape
    def initialize(county)
      super()
      @county = county
    end

    def visit_houses
      puts "Visiting all houses in #{@county.name}..."
      @agent = Mechanize.new

      House.where(:county_id => @county.id).find_each() do |house|
  #      puts "visiting house with ID: #{house.daft_id}"
        store_visit house
      end
    end
    handle_asynchronously :visit_houses

    private
      def store_visit(house)
        @agent.user_agent_alias = random_agent
    #    if we get returned a 404 of the form Scrape#visit_houses_in_county_without_delay failed with Mechanize::ResponseCodeError: 404 => Net::HTTPNotFound - 0 failed attempts
    #    that means we got the daft page.. "property has either been sold or removed from daft...."
        begin
          @agent.get(house.daft_url)
        rescue Mechanize::ResponseCodeError
          house.destroy
          return
        end

        DaftHousePage.new(@agent.page, house).save_photos
        sleep 1
      end
  end
end