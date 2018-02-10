class AddBpnumToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :bpnum, :integer
    add_column :products, :sbpnum, :integer
  end
end
