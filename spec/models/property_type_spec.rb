require 'spec_helper'

describe PropertyType do
  before :each do
    @valid_attr = { name: "Detached House", uid: "Detached", daft_identifier: "Detached House" }
  end

  it "should create a new type give valid attributes" do
    PropertyType.create! @valid_attr
  end

  it "should require a UID" do
    PropertyType.new(@valid_attr.merge(uid: "")).should_not be_valid
  end

  it "should require a name" do
    PropertyType.new(@valid_attr.merge(name: "")).should_not be_valid
  end

  it "should require a daft identifier" do
    PropertyType.new(@valid_attr.merge(daft_identifier: "")).should_not be_valid
  end

  it "should require a unique UID" do
    PropertyType.create! @valid_attr
    PropertyType.new(@valid_attr).should_not be_valid
  end

  describe "not in" do
    before(:each) do
      @detached = PropertyType.create @valid_attr
      @bungalow = Factory :property_type, name: "Bungalow", uid: "bungalow", daft_identifier: "Bungalow"
    end

    it "should return property types not listed in the supplied array" do
      PropertyType.not_in([@detached.id]).should include(@bungalow.id)
    end

    it "should not return property types listed in the supplied array" do
      PropertyType.not_in([@detached.id]).should_not include(@detached.id)
    end
  end

  describe "house associations" do
    before(:each) do
      @detached = PropertyType.create! @valid_attr
      @fermanagh = Factory :county
      @town = Factory :town, :county => @fermanagh
      @house = Factory :house, :property_type => @detached, :county => @fermanagh, :town => @town
    end

    it "should have a houses attribute" do
      @detached.should respond_to :houses
    end

    it "should retrieve all houses with that property type" do
      @detached.houses.should == [@house]
    end
  end

  describe "'building_ids' method" do
    before :each do
      @type1 = Factory :property_type
      @type2 = Factory :property_type, :uid => "Something else"
      @site = Factory :property_type, :name => "Site", :uid => "Site"
    end

    it "should have a building_ids method" do
      PropertyType.should respond_to :building_ids
    end

    it "should return an array of all the property types with structures" do
      PropertyType.building_ids.should include(@type1.id, @type2.id)
    end

    it "should not return property_type site" do
      PropertyType.building_ids.should_not include @site.id
    end
  end

  describe "reset method" do
    before(:each) do
      PropertyType.create! @valid_attr
    end

    it "should delete all searches" do
      expect {
        PropertyType.reset
      }.to change(PropertyType, :count).to(0)
    end

    it "should reset the auto increment column" do
      PropertyType.reset
      type = PropertyType.create! @valid_attr
      type.id.should == 1
    end
  end
end


# == Schema Information
#
# Table name: property_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  uid             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  daft_identifier :string(255)
#

