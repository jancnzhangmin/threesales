class AddRemarkToBuycar < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :remark, :string
  end
end
