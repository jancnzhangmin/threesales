class CreateBuycars < ActiveRecord::Migration[5.0]
  def change
    create_table :buycars do |t|
      t.integer :selleruser_id
      t.integer :amount
      t.string :status
      t.string :ordernumber

      t.timestamps
    end
  end
end
