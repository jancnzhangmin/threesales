class AddErrToAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :errpwd, :integer
    add_column :admins, :nids, :integer
    add_column :admins, :loginnum, :integer
  end
end
