class CreateProductclas < ActiveRecord::Migration[5.0]
  def change
    create_table :productclas do |t|
      t.integer :seller_id
      t.string :cla

      t.timestamps
    end
  end
end
