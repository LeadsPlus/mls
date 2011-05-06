require 'spec_helper'

describe House do
  before(:each) do
    @attr = {
       :street => 'Main Street',
       :number => 23,
       :town => 'Drogheda',
       :county_id => 4,
       :bedrooms => 5,
       :price => 345435,
       :image_url => 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
       :title => 'This is the title of the property',
       :description => 'This is the description'
    }
  end

  it "should create a new record given valid attributes" do
    House.create!(@attr)
  end

  describe "inline address method" do
    before(:each) do
      @house = House.create!(@attr)
    end

    it "should have one" do
      @house.should respond_to(:inline_address)
    end

    it "should return the houses address" do
      @house.inline_address.should == "23 Main Street, Drogheda, Co. Wicklow"
    end
  end

  describe "validations" do
    it "should require a title" do
      no_title_house = @attr.merge(:title => '')
      House.new(no_title_house).should_not be_valid
    end

    it "should require a description" do
      House.new(@attr.merge(:description => '')).should_not be_valid
    end

    it "should require a town" do
      House.new(@attr.merge(:town => '')).should_not be_valid
    end

    it "should require a county" do
      House.new(@attr.merge(:county_id => nil)).should_not be_valid
    end

    it "should require a valid county identifier" do
#      remember counties are 0 based
      invalid_counties = [-1, 32]

      invalid_counties.each do |num|
        House.new(@attr.merge(:county => num)).should_not be_valid
      end
    end

    describe "image_url" do
#      leaving these unfinished for the moment since will probably be using paperclip anyway
      it "should require an image url"
      it "should require a valid image url"
    end

    describe "house number" do
      invalid_numbers = [-1, 0, nil, 'hello']

      it "should need to be valid" do
        invalid_numbers.each { |num|
          House.new(@attr.merge(:number => num)).should_not be_valid
        }
      end
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
#  id          :integer         not null, primary key
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  image_url   :string(255)
#  description :text
#  title       :string(255)
#  county_id   :integer
#  daft_url    :string(255)
#

