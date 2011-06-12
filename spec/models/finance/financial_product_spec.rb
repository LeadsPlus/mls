require 'spec_helper'
require 'finance/financial_product'

describe Finance::FinancialProduct do
  before(:each) do
    @rate = Factory :rate
    @term = 25
    @users_deposit = 50000
  end

#  not quite sure how to test this
  it "should create a new instance given valid attributes"

  describe "effective rate method" do
    before(:each) do
      @fp = Finance::FinancialProduct.new(@rate, @term, @users_deposit)
    end

    it "should have an effective rate method" do
      @fp.should respond_to :effective_rate
    end

    it "should calc the effective rate correctly" do
      @fp.effective_rate.should == @rate.twenty_year_apr/1200
    end
  end
end