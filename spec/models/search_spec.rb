require 'spec_helper'

describe Search do
  before(:each) do
    @rate = Factory :rate # BOI variable rate
    @fixed_rate = Factory :rate, :initial_period_length => 3,
                                 :loan_type => "3 Year Fixed Rate",
                                 :lender => "AIB"
    @other_rate = Factory :rate, :lender => "Ulster Bank"
    @valid_attr = {
      min_payment: 700,
      max_payment: 1200,
      term: 25,
      deposit: 50000,
      locations: ['2343', '124', '3432'],
      lender_uids: ['BOI', 'AIB'],
      loan_type_uids: ['VR'],
      prop_type_uids: PropertyType.uids,
      bedrooms: ['5','3','2'],
      bathrooms: ['1','2']
    }
  end

  it "should create a search given valid params" do
    Search.create! @valid_attr
  end

  describe "reset method" do
    before(:each) do
      Search.create! @valid_attr
    end

    it "should delete all searches" do
      expect {
        Search.reset
      }.to change(Search, :count).to(0)
    end

    it "should reset the auto increment column" do
      Search.reset
      search = Search.create! @valid_attr
      search.id.should == 1
    end
  end

  describe "anything_blank? method" do
    before(:each) do
      @search = Search.new @valid_attr
    end

    it "should return false if nothing is blank" do
      @search.anything_blank?.should == false
    end

    it "should return true if something is blank" do
      @search.min_payment = nil
      @search.anything_blank?.should == true
    end
  end
  
  describe "validations" do
#    Many of these validations do not test what they are meant to because of the complicatedness of
#    the validation process. DO NOT TRUST THEM
    
    describe "of deposit" do
      it "should require a deposit" do
#        0.blank? => false
        Search.new(@valid_attr.merge(:deposit => nil)).should_not be_valid
      end

      it "should require a valid deposit" do
        invalid_deposits = [nil, '', -23, '-400', 0, '0', :dfef]
        invalid_deposits.each do |depos|
          Search.new(@valid_attr.merge(:deposit => depos)).should_not be_valid
        end
      end
    end

    describe "of max payment" do
      it "should require a max payment" do
        Search.new(@valid_attr.merge(:max_payment => nil)).should_not be_valid
      end

      it "should require a valid max payment" do
        invalid_payments = [nil, '', -23, '-400', 0, '0', :dfef]
        invalid_payments.each do |p|
          Search.new(@valid_attr.merge(:max_payment => p)).should_not be_valid
        end
      end

      it "should not allow max_payment to be smaller than min_payment" do
        Search.new(@valid_attr.merge(:max_payment => "300", :min_payment => "400")).should_not be_valid
      end
    end

    describe "of min_payment" do
      it "should require a min payment" do
        Search.new(@valid_attr.merge(:min_payment => nil)).should_not be_valid
      end

      it "should require a valid min payment" do
        invalid_payments = [nil, '', -23, '-400', 0, '0', :feef]
        invalid_payments.each do |p|
          Search.new(@valid_attr.merge(:min_payment => p)).should_not be_valid
        end
      end
    end

    describe "of term" do
      it "should require a term" do
        Search.new(@valid_attr.merge(:term => nil)).should_not be_valid
      end

      it "should require a valid term" do
        invalid_payments = [nil, '', -23, '-400', 0, '0', :feef]
        invalid_payments.each do |p|
          Search.new(@valid_attr.merge(:term => p)).should_not be_valid
        end
      end
    end

    describe "of locations" do
      it "should require locations" do
        Search.new(@valid_attr.merge(:locations => '')).should_not be_valid
      end

      it "should require a location of reasonable length" do
        long_locations = ['3454'] * 100
        Search.new(@valid_attr.merge(:locations => long_locations )).should_not be_valid
      end

      it 'should require the locations to be integers' do
        non_int_locations = ['dfsdfs', 'sdsd']
        Search.new(@valid_attr.merge(:locations => non_int_locations)).should_not be_valid
      end

      it "should limit the number of locations to #{MAX_LOCATIONS}" do
        loads_of_locations = ['3433'] * (MAX_LOCATIONS * 70)
        Search.new(@valid_attr.merge(:locations => loads_of_locations)).should_not be_valid
      end
    end

    describe "of lender uids" do
      it "should allow valid lenders" do
        valid_loans = [['BOI', 'AIB', 'UB'], ['BOI']]
        valid_loans.each do |uids|
          Search.new(@valid_attr.merge(:lender_uids => uids)).should be_valid
        end
      end

      it "should not allow unrecognised lender uids" do
        nonsensical = [nil, "hello", :defsd, {peope: 'faf'}]
        nonsensical.each do |what|
          Search.new(@valid_attr.merge(:lender_uids => [what])).should_not be_valid
        end
      end
    end

    describe "of loan type uids" do
      it "should allow valid loan type uids" do
        valid_loans = [['VR', 'PFR1'], ['PFR2', "PFR3", 'VR']]
        valid_loans.each do |type|
          Search.new(@valid_attr.merge(:loan_type_uids => type)).should be_valid
        end
      end

      it "should not allow unrecognised loan type uids" do
        nonsensical = [[nil, 'Variable Rate'], [:defsd, 'Variable Rate'], [{peope: 'faf'}, 'Variable Rate']]
        nonsensical.each do |what|
          Search.new(@valid_attr.merge(:loan_type_uids => [what])).should_not be_valid
        end
      end
    end

    describe "of prop_type_uids" do
      it "should allow valid prop_type_uids" do
        type = PropertyType.uids.sample(1+rand(7))
        Search.new(@valid_attr.merge(:prop_type_uids => type)).should be_valid
      end

      it "should not allow unrecognised prop_type_uids" do
        nonsensical = [[nil, 'Site'], [:defsd, 'Site'], [{peope: 'faf'}, 'Site']]
        nonsensical.each do |what|
          Search.new(@valid_attr.merge(:prop_type_uids => [what])).should_not be_valid
        end
      end
    end

    describe "of bedrooms" do
      it "should allow valid numeric bedrooms" do
        beds = ['5', '4']
        Search.new(@valid_attr.merge(:bedrooms => beds)).should be_valid
      end

      it "should allow the 'more' keyword" do
        beds = ['5', 'more']
        Search.new(@valid_attr.merge(:bedrooms => beds)).should be_valid
      end

      it "should not allow invalid beds" do
        invaid_beds = [[nil, '3'], [:dsdd, '3']]
        invaid_beds.each do |what|
          Search.new(@valid_attr.merge(:bedrooms => what)).should_not be_valid
        end
      end
    end
  end
end













# == Schema Information
#
# Table name: searches
#
#  id             :integer         not null, primary key
#  max_payment    :integer
#  deposit        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  location       :string(255)
#  min_payment    :integer
#  term           :integer
#  loan_type_uids :string(255)
#  lender_uids    :string(255)
#  max_price      :integer
#  min_price      :integer
#  rate_id        :integer
#  bedrooms       :string(255)
#  bathrooms      :string(255)
#  prop_type_uids :string(255)
#

