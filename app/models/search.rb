class Search < ActiveRecord::Base
  attr_accessible :payment, :term, :county

  validates :payment, :presence => true
  validates :term, :presence => true

  def county_names
    %w[Louth Dublin Kerry Waterford Wicklow Antrim Fermanagh Armagh Carlow Cavan Clare Cork Derry Donegal
       Down Galway Kildare Kilkenny Laois Letrim Limerick Longford Mayo Monaghan Offaly Roscommon Sligo
       Tipperary Tyrone Westmeath Wexford].freeze
  end

  def rates
    { 20 => 3.75, 25 => 3.5, 30 => 3.25, 35 => 3.0, 40 => 2.75 }
  end

  def county_choices
    i = -1
    county_names.collect do |name|
      i += 1
      [name, i]
    end
  end

  def effective_rates
    eff = {}
    rates.each do |depos, rate|
      eff[depos] = rate/1200
    end
    eff
  end

  def calc_princ(rate)
    (payment/rate)*(1-(1+rate)**-(term*12))
  end

  def principals
    princes = {}
    effective_rates.each do |depos, rate|
      princ = calc_princ(rate)
      deposit = ((princ*100)/(100 - depos) - princ).round(-3)
      princes[deposit] = princ+deposit
    end
    princes
  end

  def price_ranges
    ranges = {}
    principals.each do |deposit, principal|
      margin = principal*0.1
      min = (principal-margin).round(-3)
      max = principal.round(-3)
      ranges[deposit] = min..max
    end
    ranges
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

