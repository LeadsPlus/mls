require 'spec_helper'

describe Town do
  before(:each) do
    @valid_attr = {
      name: "Eniskillan",
      daft_id: "34535ec"
    }
    @county = Factory :county
  end

  it "should create a new instance given valid attributes" do
    save_valid_attr_town
  end

  describe "find_or_create_by_county_and_name" do
    it "should return a town if the town doesn't exist" do
      town = Town.find_or_create_by_county_and_name(@county, name: @valid_attr[:name], daft_id: @valid_attr[:daft_id])
      town.class.should == Town
    end

    it "should return a town if the town already exists" do
      save_valid_attr_town
      town = Town.find_or_create_by_county_and_name(@county, name: @valid_attr[:name], daft_id: @valid_attr[:daft_id])
      town.class.should == Town
    end

    it "should not add a record if the town already exists" do
      save_valid_attr_town
      expect {
        Town.find_or_create_by_county_and_name(@county, name: @valid_attr[:name], daft_id: @valid_attr[:daft_id])
      }.to change(Town, :count).by(0)
    end

    it "should create a new record if the town doesn't exist" do
      expect {
        Town.find_or_create_by_county_and_name(@county, name: @valid_attr[:name], daft_id: @valid_attr[:daft_id])
      }.to change(Town, :count).by(1)
    end
  end

  describe "create_or_update_by_county_and_name" do
    it "should return a town if the town doesn't exist" do
      town = Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name])
      town.class.should == Town
    end

    it "should return a town if the town already exists" do
      save_valid_attr_town
      town = Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name])
      town.class.should == Town
    end

    it "should not add a record if the town already exists" do
      save_valid_attr_town
      expect {
        Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name])
      }.to change(Town, :count).by(0)
    end

    it "should create a new record if the town doesn't exist" do
      expect {
        Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name])
      }.to change(Town, :count).by(1)
    end

    it "should update the attributes of an existant town" do
      save_valid_attr_town
      new_daft_id = "fdf32"
      town = Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name], daft_id: new_daft_id)
      town.daft_id.should == new_daft_id
    end

    it "should not update the daft_id of an existing town if it's not provided" do
      save_valid_attr_town
      town = Town.create_or_update_by_county_and_name(@county, name: @valid_attr[:name])
      town.daft_id.should == @valid_attr[:daft_id]
    end
  end

  def save_valid_attr_town
    town = Town.new(@valid_attr)
    town.county = @county
    town.save!
  end
end