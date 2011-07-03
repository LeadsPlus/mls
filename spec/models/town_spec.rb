require 'spec_helper'

describe Town do
  before(:each) do
    @valid_attr = {
      name: "Eniskillan",
      daft_id: "34535ec",
      county: 'Fermanagh'
    }
  end

  it "should create a new instance given valid attributes" do
    save_valid_attr_town!
  end

  describe "identifying_string" do
    before(:each) do
      @town = save_valid_attr_town!
    end

    it "should be correct" do
      @town.identifying_string.should == "#{@valid_attr[:name]}, Co. #{@valid_attr[:county]}"
    end
  end

  describe "reset method" do
    before(:each) do
      save_valid_attr_town!
    end

    it "should delete all records in the database" do
      expect {
        Town.reset
      }.to change(Town, :count).to(0)
    end

    it "should reset auto-increment columns to 1" do
      Town.reset
      town = save_valid_attr_town!
      town.id.should == 1
    end
  end

  describe "find_or_create_by_county_and_name" do
    it "should return a town if the town doesn't exist" do
      town = Town.find_or_create_by_county_and_name(@valid_attr)
      town.class.should == Town
    end

    it "should return a town if the town already exists" do
      save_valid_attr_town!
      town = Town.find_or_create_by_county_and_name(@valid_attr)
      town.class.should == Town
    end

    it "should not add a record if the town already exists" do
      save_valid_attr_town!
      expect {
        Town.find_or_create_by_county_and_name(@valid_attr)
      }.to change(Town, :count).by(0)
    end

    it "should create a new record if the town doesn't exist" do
      expect {
        Town.find_or_create_by_county_and_name(@valid_attr)
      }.to change(Town, :count).by(1)
    end
  end

  describe "create_or_update_by_county_and_name" do
    it "should return a town if the town doesn't exist" do
      town = Town.create_or_update_by_county_and_name(@valid_attr)
      town.class.should == Town
    end

    it "should return a town if the town already exists" do
      save_valid_attr_town!
      town = Town.create_or_update_by_county_and_name(@valid_attr)
      town.class.should == Town
    end

    it "should not add a record if the town already exists" do
      save_valid_attr_town!
      expect {
        Town.create_or_update_by_county_and_name(@valid_attr)
      }.to change(Town, :count).by(0)
    end

    it "should create a new record if the town doesn't exist" do
      expect {
        Town.create_or_update_by_county_and_name(@valid_attr)
      }.to change(Town, :count).by(1)
    end

    it "should update the attributes of an existant town" do
      save_valid_attr_town!
      new_daft_id = "fdf32"
      town = Town.create_or_update_by_county_and_name(@valid_attr.merge(daft_id: new_daft_id))
      town.daft_id.should == new_daft_id
    end

    it "should not update the daft_id of an existing town to nil" do
      save_valid_attr_town!
      town = Town.create_or_update_by_county_and_name(@valid_attr.merge(daft_id: nil))
      town.daft_id.should == @valid_attr[:daft_id]
    end
  end

  def save_valid_attr_town!
    town = Town.create!(@valid_attr)
    town
  end
end


# == Schema Information
#
# Table name: towns
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  daft_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  county     :string(255)
#

