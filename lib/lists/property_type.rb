class PropertyType
  extend Enumerable

#  Will I do better if I just include ActiveSupport?? What will that get me?
#  I think I'm messing up by using arrays instead of a hash!??
  TYPES = [
      ['Site', 'Site'],
      ['New Home', 'NewHome'],
      ['Terraced House', 'Terraced'],
      ['Detached House', 'Detached'],
      ['Bungalow', 'Bungalow'],
      ['Townhouse', 'Townhouse'],
      ['End of Terrace House', 'EoTHouse'],
      ['Semi-Detached House', 'Semi-D'],
      ['New Development', 'NewDev'],
      ['Apartment', 'Apartment']
  ].freeze

  def self.each
    TYPES.each{|type| yield(type[0], type[1]) }
  end

#  I don't think I'm making full use of Enumerable?
  def self.convert_to_name(uid_to_lookup)
    return if uid_to_lookup.blank?
    TYPES.each{|type| return type[0] if type[1] == uid_to_lookup }
  end

  def self.convert_to_uid(name_to_lookup)
    return if name_to_lookup.blank?
    TYPES.each{|type| return type[1] if type[0] == name_to_lookup }
  end

  def self.each_uid
    TYPES.each{|type| yield(type[1]) }
  end

  def self.each_name
    TYPES.each{|type| yield(type[0]) }
  end

  def self.uids
    TYPES.collect{|type| type[1]}
  end

  def self.names
    TYPES.collect{|type| type[0]}
  end
end


#  PROP_TYPES = ['Site', 'New Home', 'Terraced', 'Detached House', 'Bungalow', 'Townhouse',
#                'End of Terrace House', 'Semi-Detached House', 'New Development', 'Apartment'].freeze
#  PROP_TYPE_UIDS = ['Site', 'NewHome', 'Terraced', 'Detached', 'Bungalow', 'Townhouse',
#                'EoTHouse', 'Semi-D', 'NewDev', 'Apartment'].freeze
