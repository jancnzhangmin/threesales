class AddBuycarToDeltype < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :deltype, :integer
    add_column :buycars, :dedmoney, :float
  end
end
