class Search < ActiveRecord::Base
  attr_accessible :payment, :term, :county

  validates :payment, :presence => true
  validates :term, :presence => true

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

  def rates
#    format: minimum deposit % needed to get this rate => rate
#    { 10 => 5.15, 15 => 4.25, 20 => 3.75, 25 => 3.5, 30 => 3.25, 35 => 3.0, 40 => 2.75 }
    { 1 => 5.0, 21 => 4.5, 31 => 4.0, 41 => 3.0 }
  end

#  hash of form min_depos => eff_rate
  def effective_rates
    rates.merge(rates){|min_depos, rate| rate/1200 }
  end

  def princ(eff_rate)
    (payment/eff_rate)*(1-(1+eff_rate)**-(term*12))
  end

  def prices_per_rate
    effective_rates.merge(effective_rates){|min_depos, eff_rate| princ(eff_rate)+deposit}
  end

  def max_price
    prices_per_rate.reject { |min_depos, price| min_depos > deposit*100/price }
#    .max will give back [depos_percent, max_price]
#    .values.max will just give max_price
  end

  def matches
    matches = {}
    price_ranges.each do |deposit, range|
      matches[deposit] = House.where("price >= :min AND price <= :max AND county = :county",
                                    { :min => range.begin, :max => range.end, :county => county_names[county.to_i] })
    end
    matches
  end
end


# == Schema Information
#
# Table name: searches
#
#  id         :integer         not null, primary key
#  payment    :integer
#  deposit    :integer
#  created_at :datetime
#  updated_at :datetime
#  county     :string(255)
#

