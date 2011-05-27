class IsValidLenderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
#    Rails.logger.info "Checking is valid lender"
#    Rails.logger.debug "Attr: #{attribute}. Value: #{value}"
    record.errors[attribute] << "is invalid" unless LENDERS.include?(value)
  end
end