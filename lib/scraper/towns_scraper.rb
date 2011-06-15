module Scraper
  class TownsScraper < Scrape
    def initialize(county)
      super()
      @county = county
    end

    def refresh_towns
      url = "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c#{@county.daft_id}&search=1&submit.x=23&submit.y=11"
      @agent = Mechanize.new
      @agent.user_agent_alias = random_agent
      sleep 1
      @agent.get(url)
      scrape_town_options
    end
    handle_asynchronously :refresh_towns

    def success(job)
      puts "Job successful message delivered via hook"
    end

    private
      def scrape_town_options
        @agent.page.search("#a_id option").each do |option|
          value = option[:value]

          unless option.text =~ /^-/ || value.blank?
            text = option.text.gsub(/\(.+\)/, '').strip
            Rails.logger.debug "Option text: #{text}"
            Town.create_or_update_by_county_and_name(name: text, daft_id: value, county: @county.name)
          end
        end
      end
  end
end