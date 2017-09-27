class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :buycar_id
      t.integer :product_id
      t.integer :number
      t.float :price

      t.timestamps
    end
  end
end
