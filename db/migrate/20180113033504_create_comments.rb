class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :article_id
      t.string :openid
      t.string :name
      t.string :img
      t.text :content
      t.integer :fabulous
      t.integer :up_id
      t.datetime :pubiletime

      t.timestamps
    end
  end
end
