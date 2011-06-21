class ListingsScraperJob
  def initialize(county)
    @county = county
  end

#  remember that if I'm going to be using this, I need to turn off
#  the handle asyncronously
  def perform
#    TODO decide should I update the towns in this county first. Problably is wise
    @scraper = Scraper::ListingsScraper.new(@county).refresh_listings
  end

  def success(job)
    Rails.logger.debug "Scrape Success Registeded. "
    House.delete_all_not_scraped_in(@county)
  end

  def failure(job)
    House.reset_all_last_scraped(@county)
  end
end