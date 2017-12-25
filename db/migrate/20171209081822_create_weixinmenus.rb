class CreateWeixinmenus < ActiveRecord::Migration[5.0]
  def change
    create_table :weixinmenus do |t|
      t.string :name
      t.integer :gettype
      t.string :url
      t.string :key
      t.string :media_id
      t.integer :seller_id
      t.integer :up_id
      t.integer :number
      t.integer :sitrue

      t.timestamps
    end
  end
end
