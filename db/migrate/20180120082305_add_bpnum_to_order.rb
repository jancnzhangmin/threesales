class AddBpnumToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :bpnum, :integer
  end
end
