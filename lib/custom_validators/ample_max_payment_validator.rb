class AmpleMaxPaymentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "cannot be less than the Min. payment" if value < record.min_payment
  end
end