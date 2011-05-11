require 'spec_helper'

describe Search do
  before(:each) do
    @rate = Factory :rate
  end
  
  describe "validations" do
    before(:each) do
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

    it "should require a deposit" do
      Search.new(@valid_attr.merge(:deposit => 0)).should_not be_valid
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
#

