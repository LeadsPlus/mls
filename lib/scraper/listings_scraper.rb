# if this class gets any more complicated (I suspect it will), I should probably make seperate
# ListingScraperJob class which invokes this one and use that to pass into delayed_job like command pattern
# TODO once I'm sure the new job object works well. Refactor! and delegate!

module Scraper
  class ListingsScraper < Scrape

    def initialize(county)
      super()
      @county = county
      @url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
      @agent.get(@url)
    end

    #  this should take approx 30 mins per 10k houses
    def refresh_listings
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

  class ListingsScraperJob
    def initialize(county)
      @county = county
    end

    # Update the towns list before we scrape since we need the towns to be right
    # in order to correctly parse the daft_titles of the listings
    def before(job)
      puts "Refreshing towns and listings in #{@county.name}."
      Scraper::TownsScraper.new(@county).refresh_towns
    end

    def perform
  #    TODO decide should I update the towns in this county first. Problably is wise
      @scraper = Scraper::ListingsScraper.new(@county).refresh_listings
    end
  
    def success(job)
      Rails.logger.debug "Successfully scraped listings in #{@county.name}"
      # House.delete_all_not_scraped_in(@county)
    end
  
    #def failure
    #  House.reset_all_last_scraped(@county)
    #end
  end
end
