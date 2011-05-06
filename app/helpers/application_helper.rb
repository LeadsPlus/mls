module ApplicationHelper
# ZOMG why was it in my head that option values had to be integers???????!!!11

  def county_names
#    these are in the same order as daft url's use
    %w[Dublin Meath Kildare Wicklow Longford Offaly Westmeath Laois Louth Carlow Kilkenny Waterford
        Wexford Kerry Cork Clare Limerick Tipperary Galway Mayo Roscommon Sligo Leitrim Donegal Cavan
        Monaghan Antrim Armagh Tyrone Fermanagh Derry Down].freeze
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

  def house_address house
    "#{house.number} #{house.street}, #{house.town}, Co. #{county_to_word(house.county_id)}"
  end
end
