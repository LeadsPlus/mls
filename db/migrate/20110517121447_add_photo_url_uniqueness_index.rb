class AddPhotoUrlUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :photos, :url, :unique => true
  end

  def self.down
    remove_index :photos, :url
  end
end
