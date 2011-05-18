require "spec_helper"

describe "DaftSearchResult" do
  before(:all) do
    files = {
      "http://www.daft.ie/fermanagh_sr_p1.htm" => "doc/daft_search_results/fermanagh_sr_p1.html",
      "http://www.daft.ie/fermanagh_sr_p2.htm" => "doc/daft_search_results/fermanagh_sr_p2.html",
      "http://www.daft.ie/fermanagh_sr_p3.htm" => "doc/daft_search_results/fermanagh_sr_p3.html"
    }

    @pages = []
    files.each do |url, content|
      FakeWeb.register_uri(:get, url, :body => File.read(content), :content_type => "text/html")
      agent = Mechanize.new
      agent.get(url)
      @pages << agent.page
    end
  end

  it "should get the page successfully" do
    @pages[0].at("#search_sentence h1").text.should == "Searching for properties for sale in Co. Fermanagh"
  end

  it "should register 10 search results per page" do
    @pages[0].search(".content").count.should == 10
    @pages[1].search(".content").count.should == 10
  end

#  Price tests don't work because of a unicode fail by rspec

  describe "extract title" do
    before(:each) do
      @result = DaftSearchResult.new(@pages[0].search(".content")[0])
    end

    it "should return the right content" do
      @result.extract_title.should == "546 Loughshore Road, Carranbeg, Belleek, Co. Fermanagh - Detached House"
    end
  end

  describe "extract image_src" do
    it "should return the right src" do
      @result = DaftSearchResult.new(@pages[0].search(".content")[0])
      @result.extract_image_src.should == "./fermanagh_sr_p1_files/yC91VGVdZ4xIeFv_pjKu1osQtcwbPgzpY0SyHmSeYwRtPWRhZnQmZT0xNjB4MTIw.png"
    end
  end

  describe "room extraction" do
    it "should work when beds and baths are provided" do
      @bed_and_bath = DaftSearchResult.new(@pages[0].search(".content")[0])
      @bed_and_bath.extract_rooms.should == [4,3]
    end

    it "should return 0 when neither is provided" do
      @neither = DaftSearchResult.new(@pages[0].search(".content")[1])
      @neither.extract_rooms.should == [0,0]
    end

    it "should return [beds, 0] when only beds is provided" do
      @bedroom_only = DaftSearchResult.new(@pages[0].search(".content")[2])
      @bedroom_only.extract_rooms.should == [2, 0]
    end

    it "should return [0,0] when dealing with a site" do
      @site = DaftSearchResult.new(@pages[0].search(".content")[9])
      @site.extract_rooms.should == [0,0]
    end
  end

  describe "daft_id extraction" do
    it "should return the correct id" do
      @result = DaftSearchResult.new(@pages[0].search(".content")[0])
      @result.extract_daft_id.should == 591692
    end
  end
end