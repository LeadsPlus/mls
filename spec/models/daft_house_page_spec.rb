require "spec_helper"

describe "DaftHousePage" do
  before(:all) do
    files = {
      "http://www.daft.ie/r1.htm" => "doc/daft_search_results/r1.html",
      "http://www.daft.ie/r2.htm" => "doc/daft_search_results/r2.html",
      "http://www.daft.ie/r3.htm" => "doc/daft_search_results/r3.html"
    }

    @pages = []
    files.each do |url, content|
      FakeWeb.register_uri(:get, url, :body => File.read(content), :content_type => "text/html")
      agent = Mechanize.new
      agent.get(url)
      @pages << agent.page
    end
  end

#  it "should extract the correct addresses" do
#    @house_page = DaftHousePage.new(@pages[0], house)
#  end
end