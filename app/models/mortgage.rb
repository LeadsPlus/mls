class Mortgage
  attr_accessor :rate, :term
  attr_reader :price, :apr

  def initialize(rate, term, users_deposit, payment=0)
    @rate = rate # rate object
    @term = term
    @users_deposit = users_deposit
    @users_payment = payment
    @apr = @rate.twenty_year_apr
    calc_effective_rate
  end

  def calculate_price
    calc_principal
    @price = @principal + @users_deposit
  end

#  This function converts PFR's into a format which allows them to be compared directly with variable rates
#  returns a BigDecimal
#  def calc_avg_rate
#    if @rate.loan_type == 'Partially Fixed Rate'
#      @avg_rate = (@rate.initial_rate*@rate.initial_period_length + @rate.rolls_to*(term-@rate.initial_period_length)).to_d/term
#    else
#      @avg_rate = @rate.initial_rate.to_d
#    end
#  end

  def calc_effective_rate
    @effective_rate = @apr/1200
  end

  def calc_principal
    @principal = (@users_payment/@effective_rate)*(1-(1+@effective_rate)**-(@term*12))
  end

  def unaffordable?
    @rate.min_deposit > @users_deposit*100/@price
  end

  def pmt_at(price)
    @effective_rate / ((1+@effective_rate)**(@term*12)-1) * -((price-@users_deposit)*((1+@effective_rate)**(@term*12)))
  end

  def to_s
    string = "APR: #{@apr}, Effective Rate: #{@effective_rate.truncate(6)}, "
    string << "Principal: #{@principal.truncate(2)}, " if @principal
    string << "Price: #{@price.truncate(2)}" if @price
  end
end