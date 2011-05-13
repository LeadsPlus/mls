require 'spec_helper'

describe Search do
  before(:each) do
    @rate = Factory :rate
    @valid_attr = {
          :min_payment => 700,
          :max_payment => 1200,
          :term => 25,
          :deposit => 50000,
          :county => "Fermanagh",
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

    describe "of county" do
      it "should require a county" do
        Search.new(@valid_attr.merge(:county => '')).should_not be_valid
      end

      it "should require a valid county" do
        Search.new(@valid_attr.merge(:county => 'dfiefijde')).should_not be_valid
      end
    end

    describe "of lender" do
      it "Lender should be of a set group if present" do
        Search.new(@valid_attr.merge(:lender => 'dfiefijde')).should_not be_valid
      end
    end

    describe "of loan type" do
      it "Loan Type should be of a set group if present" do
        Search.new(@valid_attr.merge(:loan_type => 'dfiefijde')).should_not be_valid
      end
    end

    describe "of Initial Period Length" do
      it "should be of a set range if present" do
        invaid_periods = [4564, -23, "fsfewf", :fefe]
        invaid_periods.each do |p|
          Search.new(@valid_attr.merge(:initial_period_length => p)).should_not be_valid
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
#  county                :string(255)
#  min_payment           :integer
#  term                  :integer
#  loan_type             :string(255)
#  initial_period_length :integer
#  lender                :string(255)
#  max_price             :integer
#  min_price             :integer
#  rate_id               :integer
#

