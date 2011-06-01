require "spec_helper"

describe Mortgage do
  before(:each) do
    @rate = Factory :rate
    @term = 25
    @users_deposit = 50_000
    @price = 250_000
  end

  it "should create a new instance given valid attributes"

  describe "payment method" do
    before(:each) do
      @mortgage = Mortgage.new(@rate, @term, @users_deposit, @price)
    end

    it "should have a payment_required method" do
      @mortgage.should respond_to :payment_required
    end

    it "should calc the correct payment" do
      @mortgage.payment_required.should == BigDecimal.new("-1006.6182887237718", 0)
    end
  end

  describe "total paid method" do
    before(:each) do
      @mortgage = Mortgage.new(@rate, @term, @users_deposit, @price)
    end

    it "should have a total_paid method" do
      @mortgage.should respond_to :total_paid
    end

    it "should calculate the total amount paid" do
      @mortgage.total_paid.should == BigDecimal.new("-301985.48661713157", 0)
    end
  end
end