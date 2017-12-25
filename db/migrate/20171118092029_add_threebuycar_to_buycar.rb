class AddThreebuycarToBuycar < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :shopstatic, :int
    add_column :buycars, :first, :float
    add_column :buycars, :second, :float
    add_column :buycars, :third, :float
    add_column :buycars, :remarkuser, :string
    add_column :buycars, :num, :int
  end
end
