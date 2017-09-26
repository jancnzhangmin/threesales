class CreateSellerusers < ActiveRecord::Migration[5.0]
  def change
    create_table :sellerusers do |t|
      t.integer :seller_id
      t.integer :user_id
      t.integer :up_id
      t.string :openid
      t.string :qrcode
      t.datetime :qrcodetime

      t.timestamps
    end
  end
end
