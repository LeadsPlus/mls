class Mortgage
  attr_accessor :rate, :term
  attr_reader :price, :avg_rate

  def initialize(rate, term)
    @rate = rate # rate object
    @term = term
    calc_avg_rate
    calc_effective_rate
  end

#  This function converts PFR's into a format which allows them to be compared directly with variable rates
#  returns a BigDecimal
  def calc_avg_rate
    if @rate.loan_type == 'Partially Fixed Rate'
      @avg_rate = (@rate.initial_rate*@rate.initial_period_length + @rate.rolls_to*(term-@rate.initial_period_length)).to_d/term
    else
      @avg_rate = @rate.initial_rate.to_d
    end
  end

  def calc_effective_rate
    @effective_rate = @avg_rate/1200
  end

  def calc_principal payment
    @principal = (payment/@effective_rate)*(1-(1+@effective_rate)**-(term*12))
  end

#  this deposit is the monetary amount the searcher has to offer
  def calc_price payment, deposit
    @price = calc_principal(payment) + deposit
  end

  def unaffordable? deposit
    @rate.min_deposit > deposit*100/@price
  end

  def pmt_at(price)
    logger.debug "Getting a PMT for a house"
    @effective_rate / ((1+@effective_rate)**(term*12)-1) *
        -((price-deposit)*((1+@effective_rate)**(term*12)))
  end

  def to_s
    string = "Avg Rate: #{@avg_rate}, Effective Rate: #{@effective_rate.truncate(6)}, "
    string << "Principal: #{@principal.truncate(2)}, " if @principal
    string << "Price: #{@price.truncate(2)}" if @price
  end
end