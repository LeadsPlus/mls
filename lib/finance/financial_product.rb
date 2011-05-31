module Finance
  class FinancialProduct
    attr_reader :rate, :term, :users_deposit, :apr

    def initialize(rate, term, users_deposit)
      @rate = rate # rate object
      @term = term
      @users_deposit = users_deposit
      @apr = @rate.twenty_year_apr
    end

    def effective_rate
      @effective_rate ||= @apr/1200
    end
  end
end