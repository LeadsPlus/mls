class Rate < ActiveRecord::Base
end

# == Schema Information
#
# Table name: rates
#
#  id                    :integer         not null, primary key
#  initial_rate          :float
#  lender                :string(255)
#  type                  :string(255)
#  min_depos             :integer
#  initial_period_length :integer
#  svr                   :float
#  max_princ             :integer
#  min_princ             :integer
#  created_at            :datetime
#  updated_at            :datetime
#

