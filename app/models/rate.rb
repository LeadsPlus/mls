require "custom_validators/ample_ltv_validator"
# ulster bank provides min_term and max_term data

class Rate < ActiveRecord::Base
  attr_accessible :initial_rate, :lender, :lender_uid, :loan_type, :min_ltv, :max_ltv,
                  :initial_period_length, :rolls_to, :min_princ, :max_princ,
                  :min_deposit, :max_deposit, :twenty_year_apr
  has_many :searches

  before_save :calc_deposit_limits, :set_lender_uid, :set_initial_period_length

  def calc_deposit_limits
    self.min_deposit = 100-max_ltv
    self.max_deposit = 100-min_ltv
  end

  def set_lender_uid
    self.lender_uid = LENDER_UIDS[LENDERS.find_index(lender)]
  end

  def set_initial_period_length
    self.initial_period_length = LOAN_TYPES.find_index(loan_type)
  end

#  http://stackoverflow.com/questions/5748550/how-to-make-a-rails-3-dynamic-scope-conditional
  def self.scope_by_lender(lender_uids)
    where(:lender_uid => lender_uids)
  end

  def self.scope_by_loan_type(loan_type)
    where(:loan_type => loan_type)
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
      :inclusion => { :in => LENDERS }

  validates :loan_type, :presence => true,
      :inclusion => { :in => LOAN_TYPES }
  
  validates :min_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 }

  validates :max_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 },
            :ample_ltv => { :unless => :anything_blank? }

#  this is not an APR rate. Usually not available. aka Standard Variable Rate
  validates :rolls_to,
            :numericality => { :greater_than_or_equal_to => 0, :less_than => 100, :allow_blank => true }

#  these are rarely available
  validates :min_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :allow_blank => true }
  validates :max_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :allow_blank => true }

  def self.reset
    Rate.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.rates_id_seq', 1, false)"
  end
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
#  lender_uid            :string(255)
#

