class AddAkToUserpwds < ActiveRecord::Migration[5.0]
  def change
    add_column :userpwds, :ak, :string
  end
end
