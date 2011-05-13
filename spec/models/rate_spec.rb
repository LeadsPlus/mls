require 'spec_helper'

describe Rate do
  before(:each) do
    @valid_attr = {
      :initial_rate => 3.0,
      :twenty_year_apr => 3.05,
      :lender => 'AIB',
      :loan_type => 'Variable Rate',
      :min_ltv => 50,
      :max_ltv => 79,
      :max_princ => 500_000
    }
  end

  it "should create a new rate given valid attributes" do
    Rate.create! @valid_attr
  end

  describe "validations" do
    it "should reject invalid initial rates" do
      invalid = ['dfsdfdsf', -34, 101]
      invalid.each do |r|
        Rate.new(@valid_attr.merge(:initial_rate => r)).should_not be_valid
      end
    end

    it "should require a lender" do
      Rate.new(@valid_attr.merge(:lender => '')).should_not be_valid
    end

    it "should reject invalid lenders" do
      invalid_lenders = ['dfsdfdsf', 45, :sdsdw, nil]
      invalid_lenders.each do |l|
        Rate.new(@valid_attr.merge(:lender => l)).should_not be_valid
      end
    end

    it "should require a loan type" do
      Rate.new(@valid_attr.merge(:loan_type => '')).should_not be_valid
    end

    it "should reject invalid loan types" do
      invalid_loan_type = ['dfsdfdsf', 45, :sdsdw, nil]
      invalid_loan_type.each do |l|
        Rate.new(@valid_attr.merge(:loan_type => l)).should_not be_valid
      end
    end

    it "should require a max_ltv" do
      Rate.new(@valid_attr.merge(:max_ltv => '')).should_not be_valid
    end

    it "should reject invalid max ltvs" do
      invalid = ['dfsdfdsf', -34, :sdsdw, nil, 101]
      invalid.each do |l|
        Rate.new(@valid_attr.merge(:max_ltv => l)).should_not be_valid
      end
    end

    it "should require a min_ltv" do
      Rate.new(@valid_attr.merge(:min_ltv => '')).should_not be_valid
    end

    it "should reject invalid min_ltv" do
      invalid = ['dfsdfdsf', -34, :sdsdw, nil, 101]
      invalid.each do |l|
        Rate.new(@valid_attr.merge(:min_ltv => l)).should_not be_valid
      end
    end

    it "should require min_ltv to be smaller than max_ltv" do
      Rate.new(@valid_attr.merge(:min_ltv => 34, :max_ltv => 22)).should_not be_valid
    end
  end
end




# == Schema Information
#
# Table name: rates
#
#  id                    :integer         not null, primary key
#  initial_rate          :float
#  lender                :string(255)
#  loan_type             :string(255)
#  min_ltv               :integer
#  max_ltv               :integer
#  initial_period_length :integer
#  rolls_to              :float
#  max_princ             :integer
#  min_princ             :integer
#  created_at            :datetime
#  updated_at            :datetime
#  min_deposit           :integer
#  max_deposit           :integer
#  twenty_year_apr       :float
#

