class CreateSellers < ActiveRecord::Migration[5.0]
  def change
    create_table :sellers do |t|
      t.string :name
      t.text :summary
      t.string :tel
      t.string :address
      t.integer :status
      t.string :shortname

      t.timestamps
    end
  end
end
