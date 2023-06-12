class AddDisbursementReferenceToOrder < ActiveRecord::Migration[6.1]
  def up
    add_column :orders, :disbursement_id, :integer, null: true
  end

  def down
    remove_column :orders, :disbursement_id
  end
end
