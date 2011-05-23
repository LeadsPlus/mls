class MortgageBroker
  attr_reader :mortgages, :max_mortgage, :min_mortgage

#  can I just pass in the search object?
  def initialize(term, deposit, max_payment, min_payment, lender, loan_type, initial_period_length)
    @term = term
    @deposit = deposit
    @max_payment = max_payment
    @min_payment = min_payment
    @lender = lender
    @loan_type = loan_type
    @initial_period_length = initial_period_length
  end

  def viable_rates
    Rails.logger.debug "Getting viable rates"
    @viable_rates ||= Rate.scope_by_lender(@lender)
                      .scope_by_loan_type(@loan_type)
                      .scope_by_initial_period(@initial_period_length)
  end

#  If I limit people to preset term lengths, I can pre-calulate average rates, skip the calc_rates_hash
#  method and only instanciate mortgages for compeditive rates
  def lowest_rates
    Rails.logger.debug "Returning low rates or Removing high rates"
    @lowest_rates ||= viable_rates.group_by{|r| r.min_deposit }
                        .map { |min_deposit, rates| rates.min_by(&:twenty_year_apr) }.flatten(1)
  end

  def mortgages
    unless @mortgages
      Rails.logger.debug "Building the mortgages"
      @mortgages = []
      lowest_rates.each do |rate|
         @mortgages << ReverseMortgage.new(rate, @term, @deposit, @max_payment)
      end
    end
    Rails.logger.debug "Returning the mortgages"
    @mortgages
  end

  def max_mortgage
    Rails.logger.debug "Returning or Selecting the mortgage with the max affordable price"
    @max_mortgage ||= affordable_mortgages.sort! {|a,b| a.price <=> b.price }.pop
  end

  def min_mortgage
    @min_mortgage ||= ReverseMortgage.new(max_mortgage.rate, @term, @deposit, @min_payment)
  end

  def affordable_mortgages
    Rails.logger.debug "Returning or Removing unaffordable mortgages"
#    deletes items for which the block is true
    @affordable_mortgages ||= mortgages.delete_if { |mortgage| mortgage.unaffordable? }
  end

  def has_affordable_mortgages?
    affordable_mortgages.length > 0
  end

  def has_viable_rates?
    viable_rates.length > 0
  end

  def has_no_viable_rates?
    viable_rates.length == 0
  end
end