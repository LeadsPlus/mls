require 'spec_helper'

describe House do
  before(:each) do
    @county = Factory :county
    @town = Factory :town, :county => @county
    @attr = {
      price: 345435,
      image_url: 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
      daft_title: '546 Loughshore Road, Carranbeg, Belleek, Co. Fermanagh - Detached House',
      description: 'This is the description',
      county_id: 30,
      daft_id: 5453653,
      county_id: @county.id,
      town_id: @town.id,
      bedrooms: 3,
      bathrooms: 2,
      address: '546 Loughshore Road, Carranbeg',
      property_type: 'Detached House',
      last_scrape: nil,
#      property_type_uid
    }
  end

  it "should create a new record given valid attributes" do
    House.create!(@attr)
  end

  it "should set the property_type_uid before creating" do
    house = House.create(@attr)
    house.property_type_uid.should == PropertyType.convert_to_uid(@attr[:property_type])
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
      @house.title.should == "#{@attr[:address]}, #{@town.name}, Co. #{@county.name}"
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
#  id                :integer         not null, primary key
#  price             :integer
#  created_at        :datetime
#  updated_at        :datetime
#  image_url         :string(255)
#  description       :text
#  daft_title        :string(255)
#  daft_id           :integer
#  bedrooms          :integer
#  bathrooms         :integer
#  address           :string(255)
#  property_type     :string(255)
#  county_id         :integer
#  town_id           :integer
#  last_scrape       :integer
#  property_type_uid :string(255)
#

