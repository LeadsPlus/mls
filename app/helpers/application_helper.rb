module ApplicationHelper
#  Return a title on a per page basis
  def title
    base_title = "How Much House"
    @title ? "#{@title} | #{base_title}" : base_title
  end
  
  def county_names
#    these are in the same order as daft url's use
    %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down].freeze
  end

  def county_choices
    county_names.collect do |name|
      [name, name]
    end
  end

  def lender_options
    [['Bank of Ireland','Bank of Ireland'],
     ['AIB','AIB'],
     ['Ulster Bank', 'Ulster Bank'],
     ['Permanent TSB', 'Permanent TSB']]
  end

  def loan_type_options
    [['Variable Rate','Variable Rate'], ['Partially Fixed Rate','Partially Fixed Rate']]
  end

  def initial_period_length_options
    [['', nil], ['1 years', 1], ['2 years', 2], ['3 years', 3], ['4 years', 4], ['5 years', 5], ['6 years', 6]]
  end
end
