#  I also need to make a cron for doing all these tasks
# examples of what can happen when a house is sold: /Users/davidtuite/Dropbox/MLS stuff
# I can get the Lat/Long of the gaff also from a google maps initialization script on the page

# It seems that Daft automatically updates sterling prices in accordance with the exchange rate.
# This also changes the value of the "Date Entered" field

# this all needs to be updated to take advantage of the new counties model
# most of these methods should be class methods I think

# ok problem, because I'm indexing off COUNTIES but trying to link to the counties model, the index's are off
# because the counties model doesn't go back to 1 when I delete all the counties

# TODO implement this house removal. I've noted somewhere how to do it.
# TODO look into creating seperate simple JOB classes and then improving the actual scraper classes
# if I keep track of every daft_id I find in a particular run, I can delete unlisted houses when finished!??
# give every house a scrape_id param defaulting to one, if a subsequent scrape finds a house again,
# increment the scrape_id. Then run through the houses table deleting houses where scrape_id != max scrape_id
# TODO Upgrade to Mechanize 2.0: https://github.com/tenderlove/mechanize

module Scraper
  class Scrape
    AGENT_ALIASES = ["Windows IE 6", "Windows IE 7", "Windows Mozilla", "Mac Safari",
                     "Mac FireFox", "Mac Mozilla"]

    def initialize
      @agent = Mechanize.new
      add_modern_aliases
    end

    private
      def add_modern_aliases
        add_alias "Win7 Safari3","Mozilla/5.0 (Windows; U; Windows NT 6.1; da) AppleWebKit/522.15.5 (KHTML, like Gecko) Version/3.0.3 Safari/522.15.5"
        add_alias "WinXP Safari3", "Mozilla/5.0 (Windows; U; Windows NT 5.1; id) AppleWebKit/522.11.3 (KHTML, like Gecko) Version/3.0 Safari/522.11.3"
        add_alias "Mac Safari4", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_1; zh-CN) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/4.0.2 Safari/530.19"
      end

      def add_alias name, header
        Mechanize::AGENT_ALIASES[name] = header
    #    update the local list of available aliases
        AGENT_ALIASES << name
      end

      def random_agent
        AGENT_ALIASES[rand(AGENT_ALIASES.size)]
      end
  end
end
