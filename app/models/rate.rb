require "custom_validators/ample_ltv_validator"

# ulster bank provides min_term and max_term data

class Rate < ActiveRecord::Base
  attr_accessible :initial_rate, :lender, :loan_type, :min_ltv, :max_ltv,
                  :initial_period_length, :rolls_to, :min_princ, :max_princ,
                  :min_deposit, :max_deposit, :twenty_year_apr
  has_many :searches

  before_save :calc_deposit_limits

  def calc_deposit_limits
    self.min_deposit = 100-max_ltv
    self.max_deposit = 100-min_ltv
  end

#  http://stackoverflow.com/questions/5748550/how-to-make-a-rails-3-dynamic-scope-conditional
  def self.scope_by_lender(lender)
    if lender == 'Any'
      scoped
    else
      where(:lender => lender)
    end
  end

  def self.scope_by_loan_type(loan_type)
    if loan_type == 'Any'
      scoped
    else
      where(:loan_type => loan_type)
    end
  end

  def self.scope_by_initial_period(period)
    if period == nil
      scoped
    else
      where(:initial_period_length => period)
    end
  end

  def anything_blank?
    lender.blank? || loan_type.blank? || min_ltv.blank? || max_ltv.blank? || twenty_year_apr.blank?
  end

  validates :twenty_year_apr, :presence => true,
            :numericality => { :greater_than_or_equal_to => 0, :less_than => 100, :allow_blank => true }
#  sometimes nominal rates are not shown on lenders websites
  validates :initial_rate,
            :numericality => { :greater_than_or_equal_to => 0, :less_than => 100, :allow_blank => true  }

  validates :lender, :presence => true,
      :inclusion => { :in => ['Bank of Ireland', 'AIB', 'Ulster Bank', 'Permanent TSB' ] }

  validates :loan_type, :presence => true,
      :inclusion => { :in => ['Variable Rate', 'Partially Fixed Rate'] }
  
  validates :min_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 }

  validates :max_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 },
            :ample_ltv => { :unless => :anything_blank? }

  validates :initial_period_length, :numericality =>
      { :greater_than_or_equal_to => 1, :less_than => 10, :only_integer => true,
        :unless => "initial_period_length.nil?" }

#  this is not an APR rate. Usually not available. aka Standard Variable Rate
  validates :rolls_to,
            :numericality => { :greater_than_or_equal_to => 0, :less_than => 100, :allow_blank => true }

#  these are rarely available
  validates :min_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :allow_blank => true }
  validates :max_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :allow_blank => true }
end




# == Schema Information
#
# Table name: rates
#
#  id                    :integer         not null, primary key
#  initial_rate          :float
#  lender                :string(255)
#  loan_type             :string(255)
#  min_ltv               :integer
#  max_ltv               :integer
#  initial_period_length :integer
#  rolls_to              :float
#  max_princ             :integer
#  min_princ             :integer
#  created_at            :datetime
#  updated_at            :datetime
#  min_deposit           :integer
#  max_deposit           :integer
#  twenty_year_apr       :float
#

