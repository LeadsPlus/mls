class Search < ActiveRecord::Base
  attr_accessible :payment, :deposit

  validates :payment, :presence => true
  validates :deposit, :presence => true

  def effective_rate
    5.0/1200
  end

  def principals
    {
      300 => (payment/effective_rate)*(1-(1+effective_rate)**-300)+deposit,
      360 => (payment/effective_rate)*(1-(1+effective_rate)**-360)+deposit,
      420 => (payment/effective_rate)*(1-(1+effective_rate)**-420)+deposit,
    }
  end

  def price_ranges
    ranges = {}
    principals.each do |period, principal|
      margin = principal*0.1
      min = (principal-margin).round(-3)
      max = (principal+margin).round(-3)
      ranges[period] = min..max
    end
    ranges
  end

  def matches
    matches = {}
    price_ranges.each do |period, range|
      matches[period] = House.where("price >= :min AND price <= :max", { :min => range.begin, :max => range.end })
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
#

