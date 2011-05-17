require 'spec_helper'

describe Photo do
  before(:each) do
    @valid_attr = {
      :house_id => 3,
      :url => "http://mediacache-s3eu.daft.ie/PBZXUNU3DvZJXvZzZ-TD-eUvlP3myJN4RVSeNWQrkPJtPWRhZnQmaD00NTA=.jpg",
      :height => 450,
      :width => 341
    }
  end

  it "should create a photo given valid attributes" do
    Photo.create! @valid_attr
  end
  
  describe "house associations" do
    before(:each) do
      @photo = Photo.create @valid_attr
      @photo.house = @house
      @photo.save
    end

    it "should have a house attribute" do
      @photo.should respond_to :house
    end

    it "should get the associated house" do
      @photo.house.should == @house
    end
  end

  describe "validations" do
    it "should require a unique photo url" do
      @photo = Photo.create! @valid_attr
      @dup_photo = Photo.new @valid_attr
      @dup_photo.should_not be_valid
    end

    it "should disallow photo urls which are non-unique except case" do
      @photo = Photo.create! @valid_attr
      upcased_url = @valid_attr[:url].upcase
      @dup_photo = Photo.new @valid_attr.merge(:url => upcased_url)
      @dup_photo.should_not be_valid
    end
  end
end

# == Schema Information
#
# Table name: photos
#
#  id         :integer         not null, primary key
#  house_id   :integer
#  url        :string(255)
#  width      :integer
#  height     :integer
#  created_at :datetime
#  updated_at :datetime
#

