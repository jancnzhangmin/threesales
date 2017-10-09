class CreateUserpwds < ActiveRecord::Migration[5.0]
  def change
    create_table :userpwds do |t|
      t.string :password_digest

      t.timestamps
    end
  end
end
