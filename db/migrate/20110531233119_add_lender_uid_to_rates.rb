class AddLenderUidToRates < ActiveRecord::Migration
  def change
    add_column :rates, :lender_uid, :string
    rename_column :searches, :lender, :lender_uids
  end
end
