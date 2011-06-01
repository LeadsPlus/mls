require 'spec_helper'

describe Rate do
  before(:each) do
    @variable_attr = {
      initial_rate: 3.0,
      twenty_year_apr: 3.05,
      lender: 'Bank of Ireland',
      loan_type: 'Variable Rate',
      min_ltv: 50,
      max_ltv: 79,
      max_princ: 500_000
    }

    @fixed_attr = {
      initial_rate: 3.0,
      twenty_year_apr: 3.05,
      lender: 'Bank of Ireland',
      loan_type: '2 Year Fixed Rate',
      min_ltv: 1,
      max_ltv: 92
    }
  end

  it "should create a new rate given valid attributes" do
    Rate.create! @variable_attr
  end

  describe "before create callbacks" do
    before(:each) do
      @var = Rate.create! @variable_attr
      @fix = Rate.create! @fixed_attr
    end
#    TODO these need to be DRYed once I get a better lender/loan_type control system
    it "should set lender UID before creation" do
      @var.lender_uid.should == 'BOI'
    end

    it "should set initial period length before creation" do
      @fix.initial_period_length.should == 2
    end

    it "should set loan_type_uid before creation" do
      @fix.loan_type_uid.should == 'PFR2'
    end

    it "should calculate the deposit limits" do
      @var.min_deposit.should_not == nil
    end
  end

  describe "deposit limit calculations" do
    before(:each) do
      @var = Rate.create! @variable_attr
    end

    it "should calculate the correct min deposit limit" do
      @var.min_deposit.should == 21
    end

    it "should calculate the correct max deposit limit" do
      @var.max_deposit.should == 50
    end
  end

  describe "anything_blank method" do
    before(:each) do
      @var = Rate.create! @variable_attr
    end

    it "should return true if something is blank" do
      @var = Rate.new(@variable_attr.merge(:twenty_year_apr => nil))
      @var.anything_blank?.should == true
    end

    it "should return false if nothing is blank" do
      @var = Rate.new(@variable_attr)
      @var.anything_blank?.should == false
    end
  end

  describe "reset method" do
    before(:each) do
      @var = Rate.create! @variable_attr
    end

    it "should delete all records in the database" do
      expect {
        Rate.reset
      }.to change(Rate, :count).to(0)
    end

    it "should reset auto-increment columns to 1" do
      Rate.reset
      rate = Rate.create! @variable_attr
      rate.id.should == 1
    end
  end

  describe "validations" do
    it "should reject invalid initial rates" do
      invalid = ['dfsdfdsf', -34, 101]
      invalid.each do |r|
        Rate.new(@variable_attr.merge(:initial_rate => r)).should_not be_valid
      end
    end

    it "should require a lender" do
      Rate.new(@variable_attr.merge(:lender => '')).should_not be_valid
    end

    it "should reject invalid lenders" do
      invalid_lenders = ['dfsdfdsf', 45, :sdsdw, nil]
      invalid_lenders.each do |l|
        Rate.new(@variable_attr.merge(:lender => l)).should_not be_valid
      end
    end

    it "should require a loan type" do
      Rate.new(@variable_attr.merge(:loan_type => '')).should_not be_valid
    end

    it "should reject invalid loan types" do
      invalid_loan_type = ['dfsdfdsf', 45, :sdsdw, nil]
      invalid_loan_type.each do |l|
        Rate.new(@variable_attr.merge(:loan_type => l)).should_not be_valid
      end
    end

    it "should require a max_ltv" do
      Rate.new(@variable_attr.merge(:max_ltv => '')).should_not be_valid
    end

    it "should reject invalid max ltvs" do
      invalid = ['dfsdfdsf', -34, :sdsdw, nil, 101]
      invalid.each do |l|
        Rate.new(@variable_attr.merge(:max_ltv => l)).should_not be_valid
      end
    end

    it "should require a min_ltv" do
      Rate.new(@variable_attr.merge(:min_ltv => '')).should_not be_valid
    end

    it "should reject invalid min_ltv" do
      invalid = ['dfsdfdsf', -34, :sdsdw, nil, 101]
      invalid.each do |l|
        Rate.new(@variable_attr.merge(:min_ltv => l)).should_not be_valid
      end
    end

    it "should require min_ltv to be smaller than max_ltv" do
      Rate.new(@variable_attr.merge(:min_ltv => 34, :max_ltv => 22)).should_not be_valid
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
#  lender_uid            :string(255)
#  loan_type_uid         :string(255)
#

