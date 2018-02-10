class AddBpnumToBuycar < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :bpnum, :integer
    add_column :buycars, :minusbpnum, :integer
  end
end
