class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.integer :seller_id
      t.string :username
      t.string :password_digest
      t.string :login
      t.string :status
      t.string :auth

      t.timestamps
    end
  end
end
