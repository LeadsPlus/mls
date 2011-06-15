require 'spec_helper'
require Rails.root.join('lib','scraper','scraper')
require Rails.root.join('lib','scraper','title_parser')
require Rails.root.join('spec', 'fixtures', 'titles' ,'ni_titles')

describe "NiTitleParser" do
  describe "NI titles" do
    before(:all) do
      @titles = TITLE_FIXTURES
    end

    before(:each) do
      DatabaseCleaner.clean
      @title_parsers = []
      @towns = []
      @titles.each do |title|
        @county = Factory :county, :name => title[:county]
        @title_parsers << Scraper::NiTitleParser.new(title[:title], @county)
        @towns << Factory(:town, :name => title[:town_string], :county => @county.name)
      end
#      Rails.logger.debug @towns.to_s
    end

    it "should split off the location" do
      @title_parsers.each_with_index do |parser, index|
        parser.location.should == @titles[index][:location]
      end
    end

    it "should split off the property type" do
      @title_parsers.each_with_index do |parser, index|
        parser.type_string.should == @titles[index][:type]
      end
    end

    it "should contain the region in the last index of split_location" do
      @title_parsers.each_with_index do |parser, index|
        parser.region.should == @titles[index][:region]
      end
    end

    it "should retrieve the area code if it exists" do
      @title_parsers.each_with_index do |p, i|
        p.area_code.should == @titles[i][:area_code]
      end
    end

    it "should retrieve the town correctly" do
      @title_parsers.each_with_index do |p, i|
        p.town.name.should == @towns[i].name
      end
    end

    it "should form the address out of the rest of the split_locations array" do
      @title_parsers.each_with_index do |p, i|
        p.address.should == @titles[i][:address]
      end
    end
  end
end