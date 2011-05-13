class AmpleLtvValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "cannot be less than the Min. LTV" if value < record.min_ltv
  end
end