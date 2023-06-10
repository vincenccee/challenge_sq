class CreateMerchants < ActiveRecord::Migration[6.1]
  def up
    create_table :merchants do |t|
      t.string :title, null: false
      t.string :email, null: false
      t.date :live_on, null: false
      t.integer :disbursement_frequency, default: 0
      t.float :minimum_monthly_fee, default: 0.0

      t.timestamps
    end
  end

  def down
    drop_table :merchants
  end
end
