class Mortgage
  attr_accessor :rate, :min_deposit, :term
  attr_reader :effective_rate, :max_price

  def initialize(rate, term, min_deposit=1)
    @min_deposit = min_deposit
    @rate = rate # big_d
    @term = term
    calc_effective_rate
  end

  def calc_effective_rate
    @effective_rate = rate/1200
  end

  def calc_principal payment
    @principal = (payment/@effective_rate)*(1-(1+@effective_rate)**-(term*12))
  end

#  this deposit is the monetary amount the searcher has to offer
  def calc_max_price payment, deposit
    @max_price = calc_principal(payment) + deposit
  end

  def unaffordable? deposit
    @min_deposit > deposit*100/@max_price
  end

  def inspect
    "Min. Deposit: #{@min_deposit}. Rate #{@rate}"
  end

  def log_debug
    Rails.logger.debug "Min. Deposit: #{@min_deposit}. Rate #{@rate.truncate(2)}"
  end
end