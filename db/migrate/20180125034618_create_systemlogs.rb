class CreateSystemlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :systemlogs do |t|
      t.string :table
      t.integer :userid
      t.string :userip
      t.text :textout
      t.integer :selleruser_id

      t.timestamps
    end
  end
end
