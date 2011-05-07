class Rate < ActiveRecord::Base
  attr_accessible :initial_rate, :lender, :loan_type, :min_ltv, :max_ltv, :initial_period_length, :rolls_to, :min_princ, :max_princ

  validates :initial_rate, :presence => true,
            :numericality => { :greater_than_or_equal_to => 0, :less_than => 100  }
  validates :lender, :presence => true
  validates :loan_type, :presence => true
  validates :min_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 }
#            less than max_ltv
  validates :max_ltv, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1, :less_than => 100 }
#            greater than min_ltv
  validates :initial_period_length, :numericality =>
      { :greater_than_or_equal_to => 1, :less_than => 10, :only_integer => true,
        :unless => "initial_period_length.nil?" }
  validates :rolls_to, :numericality =>
      { :greater_than_or_equal_to => 0, :less_than => 100, :unless => "rolls_to.nil?" }
  validates :min_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :unless => "min_princ.nil?" }
  validates :max_princ, :numericality =>
      { :greater_than_or_equal_to => 0, :unless => "max_princ.nil?" }
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
#
