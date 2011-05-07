require 'spec_helper'

describe Rate do
  pending "add some examples to (or delete) #{__FILE__}"
end


# == Schema Information
#
# Table name: rates
#
#  id                    :integer         not null, primary key
#  initial_rate          :float
#  lender                :string(255)
#  loan_type             :string(255)
#  min_depos             :integer
#  max_depos             :integer
#  initial_period_length :integer
#  svr                   :float
#  max_princ             :integer
#  min_princ             :integer
#  created_at            :datetime
#  updated_at            :datetime
#

