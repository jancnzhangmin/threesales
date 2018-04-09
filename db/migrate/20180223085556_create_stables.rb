class CreateStables < ActiveRecord::Migration[5.0]
  def change
    create_table :stables do |t|
      t.string :name
      t.string :lable
      t.integer :stype

      t.timestamps
    end
  end
end
