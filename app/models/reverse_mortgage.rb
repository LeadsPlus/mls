class ReverseMortgage
  attr_accessor :rate, :term, :unaffordable
  attr_reader :price, :apr

  def initialize(rate, term, users_deposit, payment=0)
    @rate = rate # rate object
    @term = term
    @users_deposit = users_deposit
    @users_payment = payment
    @apr = @rate.twenty_year_apr
  end

  def price
    @price ||= principal + @users_deposit
  end

  def effective_rate
    @effective_rate ||= @apr/1200
  end

  def principal
    @principal ||= (@users_payment/effective_rate)*(1-(1+effective_rate)**-(@term*12))
  end

  def unaffordable?
    @unaffordable ||= @rate.min_deposit > @users_deposit*100/price
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