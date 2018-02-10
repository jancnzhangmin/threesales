class CreateRetoforders < ActiveRecord::Migration[5.0]
  def change
    create_table :retoforders do |t|
      t.integer :selleruser_id
      t.integer :buycar_id
      t.integer :rettype
      t.integer :ordertype
      t.string :other
      t.integer :retreason
      t.text :retcomment
      t.float :retmoney
      t.string :name
      t.string :tel
      t.string :region
      t.string :address
      t.string :logisticname
      t.string :logisticnum
      t.text :sellertext

      t.timestamps
    end
  end
end
