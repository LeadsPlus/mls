module Finance
  class MortgageBroker
    include Log
    attr_reader :mortgages, :max_mortgage, :min_mortgage

  #  can I just pass in the search object?
    def initialize(term, deposit, max_payment, min_payment, lender_uids, loan_type_uids)
      @term = term
      @deposit = deposit
      @max_payment = max_payment
      @min_payment = min_payment
      @lender_uids = lender_uids
      @loan_type_uids = loan_type_uids
    end

    def viable_rates
      log_around 'to get or calculate viable rates' do
        puts @lender_uids
        @viable_rates ||= Rate.scope_by_lender(@lender_uids).scope_by_loan_type(@loan_type_uids)
      end
    end

  #  If I limit people to preset term lengths, I can pre-calulate average rates, skip the calc_rates_hash
  #  method and only instanciate mortgages for compeditive rates
    def lowest_rates
      log_around 'to retrieve or calculate lowest rates' do
        @lowest_rates ||= viable_rates.group_by{|r| r.min_deposit }
                          .map { |min_deposit, rates| rates.min_by(&:twenty_year_apr) }.flatten(1)
      end
    end

    def mortgages
#      it appears that putting return @mortgages if @mortgages doesnt do what I think it will
      unless @mortgages
        log_around 'to build the mortgages' do
          @mortgages = []
          lowest_rates.each do |rate|
             @mortgages << ReverseMortgage.new(rate, @term, @deposit, @max_payment)
          end
        end
      end
      @mortgages
    end

    def max_mortgage
      log_around 'return or determine the max mortgage' do
        @max_mortgage ||= affordable_mortgages.sort! {|a,b| a.price <=> b.price }.pop
      end
    end

    def min_mortgage
      @min_mortgage ||= ReverseMortgage.new(max_mortgage.rate, @term, @deposit, @min_payment)
    end

    def affordable_mortgages
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
end