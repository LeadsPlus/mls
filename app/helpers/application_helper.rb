module ApplicationHelper
#  Return a title on a per page basis
  def title
    base_title = "How Much House"
    @title ? "#{@title} | #{base_title}" : base_title
  end

  def county_choices
    COUNTIES.collect {|name| [name, name] }
  end

  def lender_options
    LENDERS.collect {|name| [name, name] } << ["Any", "Any"]
  end

  def loan_type_options
    LOAN_TYPES.collect {|name| [name, name] } << ["Any", "Any"]
  end

  def initial_period_length_options
    LOAN_PERIODS.collect {|period| ["#{period} years", period]} << ["", nil]
  end
end
