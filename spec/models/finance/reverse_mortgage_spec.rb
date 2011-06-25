require "spec_helper"
require "finance/financial_product"
require "finance/reverse_mortgage"

describe Finance::ReverseMortgage do
  before(:each) do
    @rate = Factory :rate
    @term = 25
    @users_deposit = 50_000
    @payment = 1_100
  end

  it "should create a new instance given valid attributes"

  describe "principal method" do
    before(:each) do
      @mortgage = Finance::ReverseMortgage.new(@rate, @term, @users_deposit, @payment)
    end

    it "should have a payment method" do
      @mortgage.should respond_to :principal
    end

    it "should calc the correct payment" do
      @mortgage.principal.should == BigDecimal.new("218553.54950775258", 0)
    end
  end

  describe "total paid method" do
    before(:each) do
      @mortgage = Finance::ReverseMortgage.new(@rate, @term, @users_deposit, @payment)
    end

    it "should have a total_paid method" do
      @mortgage.should respond_to :total_paid
    end

    it "should calculate the total amount paid" do
      @mortgage.total_paid.should == BigDecimal.new("330000", 0)
    end
  end

  describe "affordable method" do
    before(:each) do
      @affordable_mortgage = Finance::ReverseMortgage.new(@rate, @term, @users_deposit, @payment)
      @unaffordable_mortgage = Finance::ReverseMortgage.new(@rate, @term, 2000, @payment)
    end

    it "should have an unaffordable method" do
      @affordable_mortgage.should respond_to :unaffordable?
    end

    it "should recognise an affordable mortgage as such" do
      @affordable_mortgage.unaffordable?.should == false
    end

    it "should recognise an unaffordable mortgage as such" do
      @unaffordable_mortgage.unaffordable?.should == true
    end
  end

  describe "price method" do
    before(:each) do
      @mortgage = Finance::ReverseMortgage.new(@rate, @term, @users_deposit, @payment)
    end

    it "should have a price method" do
      @mortgage.should respond_to :price
    end

    it "should return the max house price we can afford" do
      @mortgage.price.should == BigDecimal.new("218553.54950775258", 0) + @users_deposit
    end
  end
end