class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :productcla_id
      t.string :name
      t.string :spec
      t.string :model
      t.float :price
      t.text :content
      t.integer :status
      t.float :secondprice

      t.timestamps
    end
  end
end
