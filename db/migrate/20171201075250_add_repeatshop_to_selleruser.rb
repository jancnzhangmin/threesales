class AddRepeatshopToSelleruser < ActiveRecord::Migration[5.0]
  def change
    add_column :sellerusers, :repeatshop, :int
  end
end
