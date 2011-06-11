class SerializableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, serializable)
    record.errors[attribute] << "is the wrong format" unless serializable.is_a? Array
  end
end