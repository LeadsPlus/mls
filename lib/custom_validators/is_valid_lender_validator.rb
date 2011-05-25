class IsValidLenderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
#    Rails.logger.debug "Checking is valid lender"
#    Rails.logger.debug "Attr: #{attribute}. Value: #{value}"
#    value.each do |lender|
#      record.errors[attribute] << "is invalid" unless LENDERS.include?(lender)
#      break
#    end
  end
end