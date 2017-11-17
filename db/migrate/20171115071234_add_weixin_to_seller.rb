class AddWeixinToSeller < ActiveRecord::Migration[5.0]
  def change
    add_column :sellers, :access_token, :string
    add_column :sellers, :access_cardate, :datetime
    add_column :sellers, :access_time, :int
    add_column :sellers, :appid, :string
    add_column :sellers, :secret, :string
    add_column :sellers, :weixinname, :string
  end
end
