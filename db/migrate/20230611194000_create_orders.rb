class CreateOrders < ActiveRecord::Migration[6.1]
  def up
    create_table :orders do |t|
      t.belongs_to :merchant, null: false, index: true
      # this precision and scale are the default ones used for currency within rails applications
      t.decimal :amount, null: false, precision: 8, scale: 2
      t.date :purchased_at, null: false

      t.timestamps
    end
  end

  def down
    drop_table :orders
  end
end