class CreateReceives < ActiveRecord::Migration[5.0]
  def change
    create_table :receives do |t|
      t.integer :buycar_id
      t.string :name
      t.string :tel
      t.string :region
      t.string :address

      t.timestamps
    end
  end
end
