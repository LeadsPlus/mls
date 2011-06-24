# my main issue with this right now is that it's hard to tell which fixture caused a fail when I get one
# I need some way to reference the fixture in the error message

require "spec_helper"
require Rails.root.join('lib','scraper','scraper')
require Rails.root.join('lib','scraper','daft_search_result')
require Rails.root.join('spec', 'fixtures', 'property_fixture')
require "#{Rails.root}/lib/scraper/title_parser"

describe "DaftSearchResult" do
  before(:all) do
    @no_baths = PropertyFixture.new('no_baths')
    @no_beds_or_baths = PropertyFixture.new('no_beds_or_baths')
    @site = PropertyFixture.new('site')
    @type_in_beds = PropertyFixture.new('type_in_beds')

    @files = [
              PropertyFixture.new('listing'),
              PropertyFixture.new('early_dash_in_title'),
              PropertyFixture.new('has_postcode'),
              PropertyFixture.new('no_type'),
              @no_baths,
              @no_beds_or_baths,
              @site,
              @type_in_beds,
              PropertyFixture.new('auction_price')
              ]

    @fermanagh = Factory :county
  end

  describe "price methods" do
    it "should include the has_price? method which tells is if the listing has a numeric price"
#    I'm having a lot of difficuty testing these methods (I think) because of encoding issues
#    From what I can see, they do work when I run the scraper though
#    it "should get the correct price of all price" do
#      @files.each do |file|
#        if file.expected_price == 'NA'
#          expected_price = nil
#        else
#          Rails.logger.debug "Setting expected price to #{file.expected_price.to_i}"
#          expected_price = file.expected_price.to_i
#        end
#        file.extracted.price.should == expected_price
#      end
#    end
  end

  it "should get the correct daft_title" do
    @files.each do |file|
      file.extracted.daft_title.should == file.expected_daft_title
    end
  end

  # I've neglected to test all the title extraction methods here since
  # those classes have their own tests

  describe "working out the number of rooms" do
    it "should have a rooms method" do
      @files.each do |file|
        file.extracted.should respond_to :rooms
      end
    end

    it "should have a parse_beds method" do
      @files.each do |file|
        file.extracted.should respond_to :parse_beds
      end
    end

    it "should parse the rooms correctly when they are both provided" do
      @files.each do |file|
        file.extracted.rooms.to_s.should == file.expected_rooms
      end
    end

    it "should get the beds ok when there are no baths" do
      @no_baths.extracted.rooms.to_s.should == @no_baths.expected_rooms
    end

    it "should return a zeroed array when neither are given" do
      @no_beds_or_baths.extracted.rooms.to_s.should == @no_beds_or_baths.expected_rooms
    end

    it "should return a zeroed array when dealing with a site" do
      @site.extracted.rooms.to_s.should == @site.expected_rooms
    end

    it "should stil extract beds and baths when the type is in the bedrooms area" do
      @type_in_beds.extracted.rooms.to_s.should == @type_in_beds.expected_rooms
    end
  end

  describe "parsing the daft_id" do
    it "should extract the id from the show page link" do
      @files.each do |file|
        file.extracted.daft_id.should == file.expected_daft_id.to_i
      end
    end
  end

  it "should retreive the image_url with the image method"
  it "should retrieve the description with the description method"

#  describe "saving and updating houses" do
#    before(:each) do
##      rebuild one of the classes as new because the others are just build once at the start
#      @uninit_house = build_class 'no_baths'
#    end
#
#    it "should create a new town if one is not already in existance" do
#      expect {
#        @perfect.save
#      }.to change(House, :count).by(1)
#    end
#
#    it "should not create a new house if one with the same daft_id already exists" do
#      @perfect.save
#      expect {
#        @perfect.save
#      }.to change(House, :count).by(0)
#    end
#
#    it "should update a listing if the listing has changed" do
##      not exactly sure how to test this yet
#    end
#  end
end
