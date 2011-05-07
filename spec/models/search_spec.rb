require 'spec_helper'

describe Search do
#  before(:each) do
#    @attr = {
#      :term => 25,
#      :min_payment => 800,
#      :max_payment => 1000,
#      :deposit => 30_000,
#      :county => 'Clare'
#    }
#  end

  describe "methods:" do
    before(:each) do
      @search = Search.new
    end

#    I need to think of a better way to deal with these test
#    This is going to be too fragile this early
    describe "effective rate" do
      it "should exist" do
        @search.should respond_to :effective_rate
      end

      it "should return the correct answer" do
        @search.effective_rate(5.0).should == 5.0/1200
      end

      it "should deal with floats effectively" do
        @search.effective_rate(5).should == 5.0/1200
      end
    end

    describe "effective_rates" do
      it "should exist" do
        @search.should respond_to :effective_rates
      end

      it "should return a hash" do
        @search.effective_rates().class.should == Hash
      end
    end

    describe "princ" do
      it "should exist" do
        @search.should respond_to :princ
      end

      it "should return the correct answer" do
        @search.princ(@search.effective_rate(5), 1169.16).should == 199_996.56459834514
      end
    end
  end

#  remember that search is given default attributes when it is initialized
  it "should create a new search given valid attributes" do
    Search.create! @attr
  end

  describe "validations" do
    before(:each) do
      @search = Search.new
    end

    describe "min payment" do
      it "should be required" do
        @search.min_payment = nil
        @search.should_not be_valid
      end

      it "should be a valid number" do
        [0, -23, 'bananas', nil, :nan, ''].each do |paym|
          @search.min_payment = paym
        @search.should_not be_valid
        end
      end

      it "should be smaller than max_payment"
    end

    describe "max payment" do
      it "should be required" do
        @search.max_payment = nil
        @search.should_not be_valid
      end

      it "should be a valid number" do
        [0, -23, 'bananas', nil, :nan, ''].each do |paym|
          @search.max_payment = paym
          @search.should_not be_valid
        end
      end

      it "should be bigger than min_payment"
    end

    describe "deposit" do
      it "should be present" do
        @search.deposit = nil
        @search.should_not be_valid
      end

      it "should be valid" do
        [0, -23, 'bananas', nil, :nan, ''].each do |depos|
          @search.deposit = depos
        @search.should_not be_valid
        end
      end
    end

    describe "term" do
      it "should be present" do
        @search.term = nil
        @search.should_not be_valid
      end

      it "should be valid" do
        [0, -23, 'bananas', nil, :nan, ''].each do |term|
          @search.term = term
          @search.should_not be_valid
        end
      end
    end

    describe "county" do
      it "should be present" do
        @search.county_id = ''
        @search.should_not be_valid
      end

#      again I'm not exactly sure how to test this one yet
      it "should be valid" do
        [-23, 'bananas', 32, nil, :nan, ''].each do |id|
          @search.county_id = id
          @search.should_not be_valid
        end
      end
    end
  end
end







# == Schema Information
#
# Table name: searches
#
#  id          :integer         not null, primary key
#  max_payment :integer
#  deposit     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  min_payment :integer
#  term        :integer
#  county      :string(255)
#

