class AddNamemonneyToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :third, :float
    add_column :users, :senond, :float
    add_column :users, :first, :float
    add_column :users, :undthird, :float
    add_column :users, :undsenond, :float
    add_column :users, :undfirst, :float
  end
end
