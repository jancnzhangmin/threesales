class CreateSellermodels < ActiveRecord::Migration[5.0]
  def change
    create_table :sellermodels do |t|
      t.string :tablename
      t.integer :stype
      t.integer :seller_id
      t.string :modeid
      t.integer :wxtype

      t.timestamps
    end
  end
end
