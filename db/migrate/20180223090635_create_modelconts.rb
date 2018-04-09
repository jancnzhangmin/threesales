class CreateModelconts < ActiveRecord::Migration[5.0]
  def change
    create_table :modelconts do |t|
      t.string :tbname
      t.string :wxname
      t.string :content
      t.integer :stype
      t.integer :sellermodel_id

      t.timestamps
    end
  end
end
