require 'spec_helper'
require "#{Rails.root}/lib/locations_search"

describe 'LocationsSearch' do
  describe "controlled search" do
    before :each do
      DatabaseCleaner.clean
      @fermanagh = Factory :county
      @dublin = Factory :county, name: 'Dublin', daft_id: 1, id: 1
      @baldonnell = Factory :town, name: 'Baldonnell', county: @dublin.name
      @enniskillen = Factory :town
      @drog_louth = Factory :town, name: "Drogheda", county: 'Louth'
      @drog_meath = Factory :town, name: "Drogheda", county: 'Meath'
    end

    it "of exact match should should return only that county" do
      LocationsSearch.new(@fermanagh.name).controlled_search.should == [@fermanagh]
    end

    it "should be case in-sensitive" do
      LocationsSearch.new(@fermanagh.name).controlled_search.should == [@fermanagh]
    end

    it "of 'County Dublin' should return only the county dublin" do
      LocationsSearch.new("County #{@dublin.name}").controlled_search.should == [@dublin]
    end

    it "of 'County Dublin' twice should return only the county Dublin" do
      # 'c1' indicats that Dublin is already in the exclusions list
      LocationsSearch.new("County #{@dublin.name}", [@dublin.code]).controlled_search == [@dublin]
    end

    it "of 'Anywhere in Co. Dublin' should return only the county dublin" do
      LocationsSearch.new(@dublin.identifying_string).controlled_search.should == [@dublin]
    end

    it "of 'North County Dublin' should return ???"
    it "of 'Drogheda, Dublin' should add the county dublin and towns in Drogheda" do
      LocationsSearch.new('Drogheda, Dublin').controlled_search.should == [@drog_louth, @drog_meath, @dublin]
    end

    it "of 'Enniskillen, Co. Fermanagh' (Autocomplete) should get the town only" do
      LocationsSearch.new(@enniskillen.identifying_string).controlled_search.should == [@enniskillen]
    end

    it "should not include towns already in the list" do
      LocationsSearch.new(@enniskillen.identifying_string, [@dublin.code]).controlled_search.should == [@enniskillen]
    end

    it "should limit the number of towns to 60" do
      LocationsSearch.new(@dublin.name, [@dublin.code]*61).controlled_search.should == []
    end
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
