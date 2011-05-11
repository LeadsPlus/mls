class VrmAndInitialLengthNotBothSetValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[:base] << "Variable rate mortgages have no initial period length"  unless record.loan_type == 'Partially Fixed Rate'
  end
end