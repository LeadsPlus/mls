# here's how this should work
# pass in the name of a html fixture which can be found in the fixtures dir
# also pass in the name of a results file which contains the correct answers stored in a hash
# require the results hash (remember require is just a method)
# write the tester in such a way that it can compare against the results

require "spec_helper"
require Rails.root.join('lib','scraper','scraper')
require Rails.root.join('lib','scraper','daft_search_result')

describe "DaftSearchResult" do
  before(:all) do
    @perfect = parse('listing')
    @no_price = parse('no_price')
    @early_dash = parse('early_dash_in_title')
    @has_postcode = parse('has_postcode')
    @fermanagh = Factory :county
    @class = Scraper::DaftSearchResult
  end

  def parse(fixture_name)
    path_to_fixture = Rails.root.join('spec','fixtures', "#{fixture_name}.html")
    fixture = File.open(path_to_fixture)
    Nokogiri::HTML.parse(fixture)
  end

  it "should create a new instance given valid arguments" do
    @class.new(@perfect, @fermanagh).class.should == @class
  end

  describe "has_price? method" do
    it "should return a price if the price has digits" do
      perfect = @class.new(@perfect, @fermanagh)
      perfect.has_price?.should == '100,000'
    end

#    as far as I can tell, we cant use 
    it "should return nil if the price has no numeric content" do
      no_price = @class.new(@no_price, @fermanagh)
      no_price.has_price?.should == nil
    end
  end

  describe "daft_title manipulation methods" do
    before(:each) do
      @perfect = @class.new(@perfect, @fermanagh)
      @early_dash = @class.new(@early_dash, @fermanagh)
      @postcode = @class.new(@has_postcode, @fermanagh)
    end

    it "should get the correct title" do
      @perfect.daft_title.should == '546 Loughshore Road, Carranbeg, Belleek, Co. Fermanagh - Detached House'
      @early_dash.daft_title.should == 'The Chestnut - 4 Bed, 2 Storey Detached Home, Spring Meadows, Derrylin, Co. Fermanagh - New Home'
      @postcode.daft_title.should == 'Bigwood, Letter, Kesh, Co. Fermanagh, BT93 2AP - Detached House'
    end

#    the following for tests should be deleted and the associated methods made private
    it "should get the correct county index" do
      @perfect.county_index.should == 39
      @early_dash.county_index.should == 70
      @postcode.county_index.should == 21
    end

    it "should work out the correct title upto county" do
      @perfect.title_upto_county.should == '546 Loughshore Road, Carranbeg, Belleek'
      @early_dash.title_upto_county.should == 'The Chestnut - 4 Bed, 2 Storey Detached Home, Spring Meadows, Derrylin'
      @postcode.title_upto_county.should == 'Bigwood, Letter, Kesh'
    end

    it "should work out the correct county onwards" do
      @perfect.county_onwards.should == ', Co. Fermanagh - Detached House'
      @early_dash.county_onwards.should == ', Co. Fermanagh - New Home'
      @postcode.county_onwards.should == ', Co. Fermanagh, BT93 2AP - Detached House'
    end

    it "should work out the correct town index" do
      @perfect.town_index.should == 30
      @early_dash.town_index.should == 60
      @postcode.town_index.should == 15
    end

    it "should work out the correct town name" do
      @perfect.stripped_town.should == 'Belleek'
      @early_dash.stripped_town.should == 'Derrylin'
      @postcode.stripped_town.should == 'Kesh'
    end

    it "should extract the address correctly" do
      @perfect.address.should == '546 Loughshore Road, Carranbeg'
      @early_dash.address.should == 'The Chestnut - 4 Bed, 2 Storey Detached Home, Spring Meadows'
      @postcode.address.should == 'Bigwood, Letter'
    end

#    this is going to break if I use it with non Fermanagh listings
    it "should create an association with the correct Town" do
      @perfect.town.should == Town.find_by_name_and_county('Belleek', @fermanagh.name)
      @early_dash.town.should == Town.find_by_name_and_county('Derrylin', @fermanagh.name)
      @postcode.town.should == Town.find_by_name_and_county('Kesh', @fermanagh.name)
    end

    it "should work out the correct property type" do
      @perfect.type.should == 'Detached House'
      @early_dash.type.should == 'New Home'
      @postcode.type.should == 'Detached House'
    end
  end
end