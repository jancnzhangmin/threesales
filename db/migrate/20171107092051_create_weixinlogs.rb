class CreateWeixinlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :weixinlogs do |t|
      t.text :log
      t.string :url

      t.timestamps
    end
  end
end
