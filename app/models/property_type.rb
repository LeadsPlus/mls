# daft_identifier must be exactly the same as it is on daft or the scraper won't be able to fill in the field correctly
# UID will probably be obsolete soon and can then be removed

class PropertyType < ActiveRecord::Base
  attr_accessible :name, :uid, :daft_identifier
  has_many :houses

  validates :name, presence: true
  validates :daft_identifier, presence: true
  validates :uid, presence: true, uniqueness: true

  # temp method to make DB populate work until I update the searches model
  def self.uids
    all.collect {|ptype| ptype.uid }
  end

  def self.reset
    PropertyType.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.property_types_id_seq', 1, false)"
  end
end


# == Schema Information
#
# Table name: property_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  uid             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  daft_identifier :string(255)
#

