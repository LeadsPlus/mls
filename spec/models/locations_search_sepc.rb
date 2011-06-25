require 'spec_helper'
require 'locations_search'

describe 'LocationsSearch' do
  describe "controlled search" do
    before :each do
      DatabaseCleaner.clean
      @fermanagh = Factory :county
      @dublin = Factory :county, name: 'Dublin', daft_id: 1, id: 1
      @baldonnell = Factory :town, name: 'Baldonnell', county: @dublin.name
      @enniskillen = Factory :town
    end

    it "of exact match should should return only that county" do
      LocationsSearch.new('Fermanagh').controlled_search.should == [@fermanagh]
    end

    it "should be case in-sensitive" do
      LocationsSearch.new('Fermanagh').controlled_search.should == [@fermanagh]
    end

    it "of 'County Dublin' should return only the county dublin" do
      LocationsSearch.new('County Dublin').controlled_search.should == [@dublin]
    end

    it "of 'County Dublin' twice should return only the county Dublin" do
      # 'c1' indicats that Dublin is already in the exclusions list
      LocationsSearch.new('County Dublin', ['c1']).controlled_search == [@dublin]
    end

    it "of 'Anywhere in Co. Dublin' should return only the county dublin" do
      LocationsSearch.new('Anywhere in Co. Dublin').controlled_search.should == [@dublin]
    end

    it "of 'North County Dublin' should return ???"

    it "of 'Enniskillen, Co. Fermanagh' (Autocomplete) should get the town only" do
      LocationsSearch.new('Enniskillen, Co. Fermanagh').controlled_search.should == [@enniskillen]
    end

    it "should not include towns already in the list"

    it "should limit the number of towns to 60"
  end

  describe "sanitize method" do
    it "should strip 'Anywhere in Co. Dublin' to 'Dublin'" do
      LocationsSearch.new.sanitize('Anywhere in Co. Dublin').should == 'Dublin'
    end

    it "should strip 'Eniskillen, Co. Fermanagh' to 'Eniskillen Fermanagh'" do
      LocationsSearch.new.sanitize('Eniskillen, Co. Fermanagh').should == 'Eniskillen Fermanagh'
    end

    it "should strip 'County Dublin' to 'Dublin'" do
      LocationsSearch.new.sanitize('County Dublin').should == 'Dublin'
    end
  end

end
