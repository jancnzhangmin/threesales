class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :seller_id
      t.string :title
      t.string :writer
      t.datetime :pubiletime
      t.integer :number
      t.text :content

      t.timestamps
    end
  end
end
