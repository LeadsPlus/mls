require 'spec_helper'

describe House do
  before(:each) do
    @county = Factory :county
    @town = Factory :town, :county => @county
    @detached = Factory :property_type
    @attr = {
      price: 345435,
      image_url: 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
      daft_title: '546 Loughshore Road, Carranbeg, Belleek, Co. Fermanagh - Detached House',
      description: 'This is the description',
      daft_id: 5453653,
      county_id: @county.id,
      town_id: @town.id,
      property_type_id: @detached.id,
      bedrooms: 3,
      bathrooms: 2,
      address: '546 Loughshore Road, Carranbeg',
      last_scrape: nil,
      region_name: 'Co. Fermanagh'
    }
  end

  it "should create a new record given valid attributes" do
    House.create!(@attr)
  end

  describe "property_type associations" do
    before(:each) do
      @house = House.create(@attr)
    end

    it "should have a property_type attribute" do
      @house.should respond_to :property_type
    end

    it "should retrieve the associated property type" do
      @house.property_type.should == @detached
    end
  end

  describe "property type scope" do
    before :each do
      @house = House.create @attr
      @bungalow = Factory :property_type, name: "Bunglalow", uid: "bungalow", :daft_identifier => "Bungalow For Sale"
      @duplex = Factory :property_type, name: "Duplex", uid: "duplex", :daft_identifier => "Duplex For Sale"
    end

    it "should have a not_of_type scope method" do
      House.should respond_to :not_of_type
    end

    it "should return houses which don't have the included types" do
      House.not_of_type([@duplex.id, @bungalow.id]).should include(@house)
    end

    it "should not return houses which do have the included types" do
      House.not_of_type([@detached.id]).should_not include @house
    end
  end

#  TODO these tests need to be expanded to make sure I only reset houses in the county that was scraped
  describe "delete_not_scraped method" do
    before(:each) do
      @scraped_house = House.create(@attr.merge(:last_scrape => 1))
      @not_scraped_house = House.create(@attr)
    end

    it "should delete the houses which havent been scraped" do
      expect {
        House.delete_all_not_scraped
      }.to change(House, :count).by(-1)
    end

    it "should not delete the houses which have been scraped" do
      House.delete_all_not_scraped
      House.all.should == [@scraped_house]
    end

    it "should reset the last_scrape attributes of all houses to nil" do
      House.delete_all_not_scraped
      @scraped_house.last_scrape.should == nil
    end

    it "should have a method to reset all the last scrapes" do
      House.should respond_to :delete_all_last_scrapes
    end

    it "method: reset_all_last_scrapes should reset all alst scrape attrs to nil" do
      @scraped_house.last_scrape.should == nil
    end
  end

  describe "payment_required method" do
    before(:each) do
      @house = House.create! @attr
    end

    it "should exist" do
      @house.should respond_to :payment_required
    end

#    the function of this method is already tested in the mortgage class tests
  end

  describe "title method" do
    before(:each) do
      @house = House.create! @attr
    end

    it "should return the correct title" do
      @house.title.should == "#{@attr[:address]}, #{@town.name}"
    end
  end

  describe "town associations" do
    before(:each) do
      @house = House.create! @attr
    end

    it "should exist" do
      @house.should respond_to :town
    end

    it "should retrieve the correct town when called" do
      @house.town.should == @town
    end
  end

  describe "daft url method" do
    before(:each) do
      @house = House.create!(@attr)
    end

    it "should have one" do
      @house.should respond_to(:daft_url)
    end

    it "should return the daft_url" do
      @house.daft_url.should == "http://www.daft.ie/searchsale.daft?id=5453653"
    end
  end

  describe "photo associations" do
    before(:each) do
      @house = House.create!(@attr)
      @photo1 = Factory :photo, :house => @house
      @photo2 = Factory :photo, :house => @house, :url => Factory.next(:photo_url)
    end

    it "should have a photo attribute" do
      @house.should respond_to(:photos)
    end

    it "should have the right notes in the right order" do
      @house.photos.should. == [@photo1, @photo2]
    end

    it "should destroy associated photos" do
      @house.destroy
      [@photo1, @photo1].each do |photo|
        Photo.find_by_id(photo.id).should be_nil
      end
    end
  end

  describe "validations" do
    it "should require a county_id" do
      House.new(@attr.merge(:county_id => nil)).should_not be_valid
    end

    it "should require a valid daft id" do
      invalid_ids = [0, -1, nil, '']

      invalid_ids.each do |id|
        invalid_id_house = @attr.merge(:daft_id => id)
        House.new(invalid_id_house).should_not be_valid
      end
    end

    describe "image_url" do
#      leaving these unfinished for the moment since will probably be using paperclip anyway
      it "should require an image url"
      it "should require a valid image url"
    end

    describe "of price" do
      it "should require a non-zero price" do
        House.new(@attr.merge(:price => 0)).should_not be_valid
      end

      it "should require a non-nil price" do
        House.new(@attr.merge(:price => nil)).should_not be_valid
      end

      it "should require a positive price" do
        House.new(@attr.merge(:price => -234456)).should_not be_valid
      end
    end
  end
end
















# == Schema Information
#
# Table name: houses
#
#  id               :integer         not null, primary key
#  price            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  image_url        :string(255)
#  description      :text
#  daft_title       :string(255)
#  daft_id          :integer
#  bedrooms         :integer
#  bathrooms        :integer
#  address          :string(255)
#  county_id        :integer
#  town_id          :integer
#  last_scrape      :integer
#  region_name      :string(255)
#  property_type_id :integer
#

