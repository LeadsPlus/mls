class PropertyType < ActiveRecord::Base
  attr_accessible :name, :uid

  validates :name, presence: true
  validates :uid, presence: true, uniqueness: true

  def self.reset
    PropertyType.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.property_types_id_seq', 1, false)"
  end
end
