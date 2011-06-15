class AddUsageIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :usage_id, :integer
  end
end
