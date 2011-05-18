require 'spec_helper'

# http://www.daft.ie/searchsale.daft?search=1&s[cc_id]=c30&s[search_type]=sale&s[furn]=&s[refreshmap]=1&offset=0&limit=10&search_type=sale&offset=10&fr=default

describe Scrape do
  before(:each) do
#    Dir.chdir("doc/daft_search_results/")
#    offset = 0
#    Dir.glob("*.html") do |filename|
##      file start reading in the directory last traversed to by Dir
#      stream = File.read "#{filename}"
#      FakeWeb.register_uri(:get, "http://www.daft.ie/searchsale.daft?s%5Bcc_id%5D=c30&offset=#{offset}&search=1&submit.x=23&submit.y=11",
#                          :body => stream, :content_type => "text/html")
#      offset += 10
#    end
    @scrape = Scrape.new
  end

  it "should have a method to extract beds and bathrooms" do
    @scrape.should respond_to(:extract_bedrooms)
  end

  describe "extract bedrooms" do
    it "should return beds and bathrooms given valid input" do
      valid = ['<span class="bedrooms">6 Bedrooms, 3 Bathrooms</span>',
               '<span class="bedrooms">2 Bedrooms</span>',
               '<span class="bedrooms">3 Bedrooms, 1 Bathroom</span>',
               '<span class="bedrooms">30 Acre Site</span>']

      @scrape.extract_bedrooms(valid[0]).should == [6,3]
    end
  end
end