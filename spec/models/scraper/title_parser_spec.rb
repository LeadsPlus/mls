require 'spec_helper'
require Rails.root.join('lib','scraper','scraper')
require Rails.root.join('lib','scraper','title_parser')
require Rails.root.join('spec', 'fixtures', 'titles' ,'cork_titles')
require Rails.root.join('spec', 'fixtures', 'titles' ,'roscommon')

# these will be broken until I seed some towns into the database

describe "TitleParser" do
    before(:all) do
      @titles = CORK_TITLES + ROSCOMMON_TITLES
    end

    before(:each) do
      DatabaseCleaner.clean
      @title_parsers = []
      @towns = []
      @titles.each do |title|
        @county = Factory :county, name: title[:county]
        @title_parsers << Scraper::TitleParser.new(title[:title], @county)
        @towns << Factory(:town, :name => title[:town_string], :county => @county.name)
      end
      Rails.logger.debug @towns.to_s
    end

    it "should split off the location" do
      @title_parsers.each_with_index do |parser, index|
        parser.location.should == @titles[index][:location]
      end
    end

    it "should contain the region in the last index of split_location" do
      @title_parsers.each_with_index do |parser, index|
        parser.region.should == @titles[index][:region]
      end
    end

    it "should retrieve the town correctly" do
      @title_parsers.each_with_index do |p, i|
        p.town.should == @towns[i]
      end
    end

    it "should form the address out of the rest of the split_locations array" do
      @title_parsers.each_with_index do |p, i|
        p.address.should == @titles[i][:address]
      end
    end

    describe "property type finders" do
      it "should split off the property type" do
        @title_parsers.each_with_index do |parser, index|
          parser.type_string.should == @titles[index][:type]
        end
      end

      it "should find the property type in the database"
    end
end
