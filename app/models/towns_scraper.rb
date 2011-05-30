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

  private
    def scrape_town_options
      @agent.page.search("#a_id option").each do |option|
        value = option[:value]
        text = option.text.gsub(/(- | -)/, "").gsub(/ \(.+\)/, "")

        unless text =~ /(-+|Dublin Commuter)/ || value.blank?
          Town.create_or_update_by_county_and_name(@county, { name: text, daft_id: value })
        end
      end
    end
end
