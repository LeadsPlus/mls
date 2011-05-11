require 'spec_helper'

describe Rate do
  before(:each) do
    @valid_attr = {
      :initial_rate => 3.0,
      :lender => 'AIB',
      :loan_type => 'Variable Rate',
      :min_ltv => 50,
      :max_ltv => 79,
      :max_princ => 500_000
    }
  end

  describe "validations" do
    it "should require an initial rate" do
      Rate.new(@valid_attr.merge(:initial_rate => '')).should_not be_valid
    end

    it "should require a lender" do
      Rate.new(@valid_attr.merge(:lender => '')).should_not be_valid
    end

    it "should require a loan type" do
      Rate.new(@valid_attr.merge(:loan_type => '')).should_not be_valid
    end

    it "should require a max_ltv" do
      Rate.new(@valid_attr.merge(:max_ltv => '')).should_not be_valid
    end

    it "should require a min_ltv" do
      Rate.new(@valid_attr.merge(:min_ltv => '')).should_not be_valid
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
#

