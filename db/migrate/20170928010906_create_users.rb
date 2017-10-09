class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :password_digest
      t.string :vcode
      t.datetime :vcodetime

      create_table :userpwds do |t|
        t.belongs_to :user, index: true
        t.string :password_digest
        t.timestamps
        end
    end
  end
end
