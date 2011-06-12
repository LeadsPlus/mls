module CustomValidators
  class SerializableIntsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, array)
#      Rails.logger.debug "Integer Array: #{array.to_s}"
#      no oint running these validations if the user left locations blank
      return if array.blank?
#      just return if something really crazy is going on
      record.errors[attribute] << "is the wrong format" and return unless array.is_a? Array
#      if things look ok, test the elements
      array.each do |number|
#        more is the keyword for large numeric ranges
        unless number =~ /\d+/ || number =~ /more/
          record.errors[attribute] << "is invalid"
          break
        end
      end
    end
  end

  class SerializableStringsValidator < ActiveModel::EachValidator
    def validate_each record, attribute, array
#      Rails.logger.debug "String Array: #{array.to_s}"
      record.errors[attribute] << "is the wrong format" and return unless array.is_a? Array
      array.each do |string|
        unless string.is_a? String and string.length < 40
          record.errors[attribute] << "is invalid"
          break
        end
      end
    end
  end

  class AmpleMaxPaymentValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "cannot be less than the Min. payment" if value < record.min_payment
    end
  end

  class AmpleLtvValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "cannot be less than the Min. LTV" if value < record.min_ltv
    end
  end

  class IsValidLenderValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
#     Rails.logger.info "Checking is valid lender"
#     Rails.logger.debug "Attr: #{attribute}. Value: #{value}"
      record.errors[attribute] << "is invalid" unless LENDERS.include?(value)
    end
  end

  class ValidLocationsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, locations_array)
      unless locations_array.nil?
        record.errors[:base] << "The maximum number of areas is #{MAX_LOCATIONS}." unless
            locations_array.size < MAX_LOCATIONS
      end
    end
  end

  class VrmAndInitialLengthNotBothSetValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[:base] << "Variable rate mortgages have no initial period length"  unless record.loan_type == 'Partially Fixed Rate'
    end
  end
end