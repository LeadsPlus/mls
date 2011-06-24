module Scraper
  class TownsScraper < Scrape
    def initialize(county)
      super()
      @county = county
      @url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
    end

    def refresh_towns
      sleep 1
      @agent.user_agent_alias = random_agent
      @agent.get(@url)
      scrape_town_options
    end

    private
      def scrape_town_options
        @agent.page.search("#a_id option").each do |option|
          value = option[:value]

          unless option.text =~ /^-/ || value.blank?
            text = option.text.gsub(/\(.+\)/, '').strip
            Town.create_or_update_by_county_and_name(name: text, daft_id: value, county: @county.name)
          end
        end
      end
  end

  class TownsScraperJob
    def initialize(county)
      @county = county
    end

    def perform
      Scraper::TownsScraper.new(@county).refresh_towns
    end

    def success(job)
      puts "Scraping of towns in #{@county.name} successful."
      puts "Job details: #{job.inspect}"
    end
  end
end
