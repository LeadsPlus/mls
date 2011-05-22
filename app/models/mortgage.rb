class Mortgage < FinancialProduct
  attr_reader :payment, :total_paid

  def initialize(rate, term, users_deposit, price)
    super(rate, term, users_deposit)
    @price = price
  end

  def payment_required
    @payment ||= effective_rate / ((1+effective_rate)**(@term*12)-1) * -((@price-@users_deposit)*((1+effective_rate)**(@term*12)))
  end

  def total_paid
    @total_paid ||= @term*12*payment_required
  end

  def to_s
    unless @string
      @string = "APR: #{@apr}, Effective Rate: #{effective_rate.truncate(6)}, "
      @string << "PMT: #{pmt.truncate(2)}, "
    end
    @string
  end
end