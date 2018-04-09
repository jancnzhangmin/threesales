class AddBuycarToDeltype < ActiveRecord::Migration[5.0]
  def change
    add_column :buycars, :deltype, :integer
  end
end
