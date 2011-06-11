class ValidLocationsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, locations_array)
      max_locations = 60
      unless locations_array.nil?
        record.errors[:base] << "The maximum number of areas is #{max_locations}." unless
            locations_array.size < max_locations
      end
    end
end