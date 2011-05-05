module ApplicationHelper

  def county_names
    %w[Louth Dublin Kerry Waterford Wicklow Antrim Fermanagh Armagh Carlow Cavan Clare Cork Derry Donegal
       Down Galway Kildare Kilkenny Laois Letrim Limerick Longford Mayo Monaghan Offaly Roscommon Sligo
       Tipperary Tyrone Westmeath Wexford].freeze
  end

  def county_choices
    i = -1
    county_names.collect do |name|
      i += 1
      [name, i]
    end
  end

  def county_to_word(county)
    county_names[county]
  end
end
