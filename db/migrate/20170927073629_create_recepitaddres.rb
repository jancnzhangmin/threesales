class CreateRecepitaddres < ActiveRecord::Migration[5.0]
  def change
    create_table :recepitaddres do |t|
      t.integer :user_id
      t.string :name
      t.string :tel
      t.string :region
      t.string :address

      t.timestamps
    end
  end
end
