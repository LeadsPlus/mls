class Search < ActiveRecord::Base
  attr_accessible :min_payment, :max_payment, :deposit, :county
  after_initialize :init

  def init
    self.min_payment ||= 800
    self.max_payment ||= 1000
    self.deposit ||= 50_000
    self.county ||= 'Wicklow'
  end

  def term
    25
  end

  validates :max_payment, :presence => true
  validates :deposit, :presence => true

#  def self.county_names
#    %w[Louth Dublin Kerry Waterford Wicklow Antrim Fermanagh Armagh Carlow Cavan Clare Cork Derry Donegal
#       Down Galway Kildare Kilkenny Laois Letrim Limerick Longford Mayo Monaghan Offaly Roscommon Sligo
#       Tipperary Tyrone Westmeath Wexford].freeze
#  end
#
#  def self.county_choices
#    i = -1
#    county_names.collect do |name|
#      i += 1
#      [name, i]
#    end
#  end

#  Do I need BigDecimals here?
  def rates
#    format: minimum deposit % needed to get this rate => rate
#    { 10 => 5.15, 15 => 4.25, 20 => 3.75, 25 => 3.5, 30 => 3.25, 35 => 3.0, 40 => 2.75 }
    { 1 => 5.0, 21 => 4.5, 31 => 4.0, 41 => 3.0 }
  end

  def eventual_rate
    rates[affordable_prices.max[0]]
  end

  def effective_rate(rate)
    rate/1200
  end

#  hash of form min_depos => eff_rate
  def effective_rates
    rates.merge(rates){|min_depos, rate| effective_rate rate }
  end

  def princ(eff_rate, payment)
    (payment/eff_rate)*(1-(1+eff_rate)**-(term*12))
  end

  def max_prices_per_rate
    effective_rates.merge(effective_rates){|min_depos, eff_rate| princ(eff_rate, max_payment)+deposit}
  end

#  I'm not too sure that this is the right solution for min price.
#  Need to study the excel sheet more to try work it out.
  def min_price
    princ(effective_rates.values.max, min_payment)+deposit
  end

  def affordable_prices
    max_prices_per_rate.reject { |min_depos, price| min_depos > deposit*100/price }
#    .max will give back [depos_percent, max_price]
#    .values.max will just give max_price
  end

  def pmt_at(price)
    effective_rate(eventual_rate) / ((1+effective_rate(eventual_rate))**(term*12)-1) *
        -((price-deposit)*((1+effective_rate(eventual_rate))**(term*12)))
  end

  def matches
    House.where("price >= :min AND price <= :max AND county = :county",
                { :min => min_price, :max => affordable_prices.values.max, :county => $county_names[county.to_i] })
  end
end




# == Schema Information
#
# Table name: searches
#
#  id          :integer         not null, primary key
#  max_payment :integer
#  deposit     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  county      :string(255)
#  min_payment :integer
#

