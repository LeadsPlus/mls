require 'spec_helper'

# TODO these tests aren't complete
describe LocationsController do
  
  # These need to be JS enabled requests since
  # this action doesn't respond to html reuests
  describe "'GET' index" do
    it "should be successful" do
      get 'index', name: 'Dublin'
      response.should be_success
    end

    it "should retrieve a county when user enters an exact match county name"
    it "should return one town when user enters an exact match town name"
  end

  describe "controlled search" do
    before :each do
      DatabaseCleaner.clean
      @cont = LocationsController.new()
      @fermanagh = Factory :county
      @dublin = Factory :county, name: 'Dublin', daft_id: 1, id: 1
      @baldonnell = Factory :town, name: 'Baldonnell', county: @dublin.name
      @enniskillen = Factory :town
    end

    it "of exact match should should return only that county" do
      @cont.controlled_search('Fermanagh').should == [@fermanagh]
    end

    it "should be case in-sensitive" do
      @cont.controlled_search('Fermanagh').should == [@fermanagh]
    end

    it "of 'County Dublin' should return only the county dublin" do
      @cont.controlled_search('County Dublin').should == [@dublin]
    end

    it "of 'County Dublin' twice should return only the county Dublin" do
      # 'c1' indicats that Dublin is already in the exclusions list
      @cont.controlled_search('County Dublin', ['c1']).should == [@dublin]
    end

    it "of 'Anywhere in Co. Dublin' should return only the county dublin" do
      @cont.controlled_search('County Dublin').should == [@dublin]
    end

    it "of 'North County Dublin' should return ???"

    it "of 'Enniskillen, Co. Fermanagh' (Autocomplete) should get the town only" do
      @cont.controlled_search('Enniskillen, Co. Fermanagh').should == [@enniskillen]
    end

    it "should not include towns already in the list"

    it "should limit the number of towns to 60"
  end

  describe "sanitize method" do
    before :each do
      @cont = LocationsController.new()
    end

    it "should strip 'Anywhere in Co. Dublin' to 'Dublin'" do
      @cont.sanitize('Anywhere in Co. Dublin').should == 'Dublin'
    end

    it "should strip 'Eniskillen, Co. Fermanagh' to 'Eniskillen Fermanagh'" do
      @cont.sanitize('Eniskillen, Co. Fermanagh').should == 'Eniskillen Fermanagh'
    end

    it "should strip 'County Dublin' to 'Dublin'" do
      @cont.sanitize('County Dublin').should == 'Dublin'
    end
  end
end
