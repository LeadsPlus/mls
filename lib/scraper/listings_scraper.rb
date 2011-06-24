# if this class gets any more complicated (I suspect it will), I should probably make seperate
# ListingScraperJob class which invokes this one and use that to pass into delayed_job like command pattern
# TODO once I'm sure the new job object works well. Refactor! and delegate!

module Scraper
  class ListingsScraper < Scrape
    def initialize(county)
      super()
      @county = county
    end

    #  this should take approx 30 mins per 10k houses
    def refresh_listings
      url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
      puts "Scraping #{@county.name} via it's Daft county ID: #{@county.daft_id}..."
  #    trying to put Mechanize initialization in the initialize method makes SJ prone to failure
      @agent = Mechanize.new
      @agent.get(url)

      while next_page_link do
        scrape_house_listings
  #      sleep for a second so we don't kill daft
        sleep 1
        @agent.user_agent_alias = random_agent
        next_page_link.click
      end
    end
    
    private
      def next_page_link
        @agent.page.link_with(:text => "Next Page \u00BB")
      end

      def scrape_house_listings
        @agent.page.search(".content").each do |listing|
          DaftSearchResult.new(listing, @county).save
        end
      end
  end
end
