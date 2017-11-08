class CreateWeixinlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :weixinlogs do |t|
      t.string :ToUserName
      t.string :FromUserName
      t.string :CreateTime
      t.string :MsgType
      t.string :Event
      t.string :EventKey
      t.string :Ticket

      t.timestamps
    end
  end
end
