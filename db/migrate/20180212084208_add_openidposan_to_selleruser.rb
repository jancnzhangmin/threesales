class AddOpenidposanToSelleruser < ActiveRecord::Migration[5.0]
  def change
    add_column :sellerusers, :openidposan, :string
  end
end
