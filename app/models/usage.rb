require "digest/md5"

class Usage < ActiveRecord::Base
  attr_accessible :identifier, :user_agent, :ip_address
  has_many :searches

  before_save do
    self.identifier = Digest::MD5.hexdigest(ip_address + user_agent)
  end

  def self.reset
    Usage.delete_all
    ActiveRecord::Base.connection.execute "SELECT setval('public.usages_id_seq', 1, false)"
  end
end

# == Schema Information
#
# Table name: usages
#
#  id         :integer         not null, primary key
#  identifier :string(32)
#  user_agent :string(255)
#  ip_address :string(255)
#  created_at :datetime
#  updated_at :datetime
#

