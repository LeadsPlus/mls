class Mortgage
  attr_accessor :rate, :term
  attr_reader :apr, :pmt

  def initialize(rate, term, users_deposit, price)
    @rate = rate # rate object
    @term = term
    @price = price
    @users_deposit = users_deposit
    @apr = @rate.twenty_year_apr
  end

  def effective_rate
    @effective_rate ||= @apr/1200
  end

  def pmt
    @pmt ||= effective_rate / ((1+effective_rate)**(@term*12)-1) * -((@price-@users_deposit)*((1+effective_rate)**(@term*12)))
  end

  def total_paid
    @total_paid ||= @term*12*pmt
  end

  def to_s
    unless @string
      @string = "APR: #{@apr}, Effective Rate: #{effective_rate.truncate(6)}, "
      @string << "PMT: #{pmt.truncate(2)}, "
    end
    @string
  end
end