require 'spec_helper'
require Rails.root.join('lib','scraper','scraper')
require Rails.root.join('lib','scraper','title_parser')
require Rails.root.join('spec', 'fixtures', 'titles' ,'cork_titles')
require Rails.root.join('spec', 'fixtures', 'titles' ,'roscommon')

describe "TitleParser" do
    before(:all) do
      @titles = CORK_TITLES + ROSCOMMON_TITLES
      @county = Factory :county, :name => 'Cork'

      @title_parsers = []
      @titles.each do |title|
        @title_parsers << Scraper::TitleParser.new(title[:title], @county)
      end
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

    it "should retrieve the town correctly" do
      @title_parsers.each_with_index do |p, i|
        p.town_string.should == @titles[i][:town_string]
      end
    end

    it "should form the address out of the rest of the split_locations array" do
      @title_parsers.each_with_index do |p, i|
        p.address.should == @titles[i][:address]
      end
    end
end