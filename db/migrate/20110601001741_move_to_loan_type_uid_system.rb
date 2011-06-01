class MoveToLoanTypeUidSystem < ActiveRecord::Migration
  def change
    rename_column :searches, :loan_type, :loan_type_uids
    add_column :rates, :loan_type_uid, :string
    remove_column :searches, :initial_period_length
  end
end
