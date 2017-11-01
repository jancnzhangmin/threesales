class AddNoticesToNotices < ActiveRecord::Migration[5.0]
  def change
    add_column :notices, :seller_id, :integer
    add_column :notices, :status, :integer
    add_column :notices, :recommend, :integer
  end
end
