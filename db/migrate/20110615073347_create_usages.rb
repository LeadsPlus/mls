class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :identifier, :limit => 32
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
  end
end
