class AddSelleridToBuycar < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :seller_id, :integer
    add_column :buycars, :user_id, :integer
  end
end
