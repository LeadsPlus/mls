class ReverseMortgage < FinancialProduct
  attr_reader :price, :total_paid

  def initialize(rate, term, users_deposit, payment)
    super(rate, term, users_deposit)
    @users_payment = payment
  end

  def price
    @price ||= principal + @users_deposit
  end

  def principal
    @principal ||= (@users_payment/effective_rate)*(1-(1+effective_rate)**-(@term*12))
  end

  def total_paid
    @total_paid ||= BigDecimal.new(@users_payment.to_s, 0)*@term*12
  end

#  doing @unaffordable ||= xyz is not a good idea. See eloquent ruby.
  def unaffordable?
    @rate.min_deposit > @users_deposit*100/price
  end

  def to_s
    unless @string
      @string = "APR: #{@apr}, Effective Rate: #{effective_rate.truncate(6)}, "
      @string << "Principal: #{principal.truncate(2)}, "
      @string << "Price: #{price.truncate(2)}"
    end
    @string
  end
end