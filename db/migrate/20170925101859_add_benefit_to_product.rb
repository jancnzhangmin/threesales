class AddBenefitToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :first, :float
    add_column :products, :second, :float
    add_column :products, :third, :float
    add_column :products, :sfirst, :float
    add_column :products, :ssecond, :float
    add_column :products, :sthird, :float
  end
end
