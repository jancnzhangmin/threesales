class AddSelleridToSelleruser < ActiveRecord::Migration[5.0]
  def change
    add_column :sellerusers, :qrcode_ticket, :string
    add_column :sellerusers, :qrcode_cardate, :datetime
  end
end
