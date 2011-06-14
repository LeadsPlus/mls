require 'spec_helper'

describe "TitleParser" do
  describe "dublin titles" do
    it "should extract the reigen identifier correctly" do
      titles = [
        {
          title: '10 Bishops Orchard, Tyrrelstown, Dublin 15, North Co. Dublin - Semi-Detached House',
          ans: 'North Co. Dublin'
        },
        {
          title: '50 The Links, Donabate, North Co. Dublin - Semi-Detached House',
          ans: 'North Co. Dublin'
        },
        {
          title: '2 Bedroom “own Door” Apartment Fully Furnished Sho, Castlegrange, Clonsilla, Dublin 15, West Co. Dublin - New Development',
          ans: 'West Co. Dublin'
        },
        {
          title: '122 Ratoath Estate, Cabra, Dublin 7, North Dublin City - Semi-Detached House',
          ans: 'North Dublin City'
        }
      ]

      titles.each do |set|
        parser = Scraper::TitleParser.new(set[:title])
        parser.region.should == set[:ans]
      end
    end
  end

    it "should get the correct title" do
      @files.each do |file|
        file.extracted.daft_title.should == file.expected_daft_title
      end
    end

#    the following for tests should be deleted and the associated methods made private
    it "should get the correct county index" do
      @files.each do |file|
        file.extracted.county_index.should == file.expected_county_index.to_i
      end
    end

    it "should work out the correct title upto county" do
      @files.each do |file|
        file.extracted.title_upto_county.should == file.expected_title_upto_county
      end
    end

    it "should work out the correct county onwards" do
      @files.each do |file|
        file.extracted.county_onwards.should == file.expected_county_onwards
      end
    end

    it "should work out the correct town index" do
      @files.each do |file|
        file.extracted.town_index.should == file.expected_town_index.to_i
      end
    end

    it "should work out the correct town name" do
      @files.each do |file|
        file.extracted.stripped_town.should == file.expected_stripped_town
      end
    end

    it "should extract the address correctly" do
      @files.each do |file|
        file.extracted.address.should == file.expected_address
      end
    end

#    this is going to break if I use it with non Fermanagh listings
    it "should create an association with the correct Town" do
      @files.each do |file|
        file.extracted.town.should == Town.find_by_name_and_county(file.expected_town, @fermanagh.name)
      end
    end

    it "should work out the correct property type" do
      @files.each do |file|
        file.extracted.type.should == file.expected_type
      end
    end
end