class AddThreebuycarToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :first, :float
    add_column :orders, :second, :float
    add_column :orders, :third, :float
    add_column :orders, :name, :string
    add_column :orders, :spec, :string
    add_column :orders, :model, :string
    add_column :orders, :shopstatus, :int
  end
end
