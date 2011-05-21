require 'spec_helper'

describe Search do
  before(:each) do
    @rate = Factory :rate # BOI variable rate
    @fixed_rate = Factory :rate, :initial_period_length => 3,
                                 :loan_type => "Partially Fixed Rate",
                                 :lender => "AIB"
    @other_rate = Factory :rate, :lender => "Ulster Bank"
    @valid_attr = {
          :min_payment => 700,
          :max_payment => 1200,
          :term => 25,
          :deposit => 50000,
          :location => "Fermanagh",
          :lender => 'Any',
          :loan_type => 'Any',
          :initial_period_length => ''
      }
  end

  it "should create a search given valid params" do
    Search.create! @valid_attr
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
        invalid_payments = [nil, '', -23, '-400', 0, '0', :dfef]
        invalid_payments.each do |p|
          Search.new(@valid_attr.merge(:max_payment => p)).should_not be_valid
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

    describe "of location" do
      it "should require a location" do
        Search.new(@valid_attr.merge(:location => '')).should_not be_valid
      end

      it "should require a location of reasonable length" do
        long_location = "a" * 256
        Search.new(@valid_attr.merge(:location => long_location )).should_not be_valid
      end
    end

    describe "of lender" do
      it "should be of a set group if present" do
        Search.new(@valid_attr.merge(:lender => 'dfiefijde')).should_not be_valid
      end

      it "should allow valid lenders" do
        valid_loans = ['Bank of Ireland', 'AIB', 'Ulster Bank']
        valid_loans.each do |loan|
          Search.new(@valid_attr.merge(:lender => loan)).should be_valid
        end
      end

      it "should allow the 'Any' lender" do
        Search.new(@valid_attr.merge(:lender => 'Any')).should be_valid
      end
    end

    describe "of loan type" do
      it "should be required to be of a set group if present" do
        Search.new(@valid_attr.merge(:loan_type => 'dfiefijde')).should_not be_valid
      end

      it "should allow valid loan types" do
        valid_loans = ['Variable Rate', 'Partially Fixed Rate']
        valid_loans.each do |type|
          Search.new(@valid_attr.merge(:loan_type => type)).should be_valid
        end
      end

      it "should allow the 'Any' type" do
        Search.new(@valid_attr.merge(:loan_type => 'Any')).should be_valid
      end
    end

    describe "of Initial Period Length" do
      it "should be required if loan_type is non Variable rate" do
        Search.new(@valid_attr.merge(:loan_type => 'Varibale Rate')).should_not be_valid
      end

      it "should accept valid paramaters under the right conditions" do
        Search.new(@valid_attr.merge(:loan_type => 'Partially Fixed Rate',
                                     :initial_period_length => "3")).should be_valid
      end

      it "should be of a set range if present" do
        invaid_periods = [4564, -23, "fsfewf", :fefe]
        invaid_periods.each do |p|
          Search.new(@valid_attr.merge(:loan_type => "Partially Fixed Rate",
                                       :initial_period_length => p)).should_not be_valid
        end
      end
    end
  end
end










# == Schema Information
#
# Table name: searches
#
#  id                    :integer         not null, primary key
#  max_payment           :integer
#  deposit               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  location              :string(255)
#  min_payment           :integer
#  term                  :integer
#  loan_type             :string(255)
#  initial_period_length :integer
#  lender                :string(255)
#  max_price             :integer
#  min_price             :integer
#  rate_id               :integer
#

