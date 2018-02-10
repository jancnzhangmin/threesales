class CreateRetcauses < ActiveRecord::Migration[5.0]
  def change
    create_table :retcauses do |t|
      t.integer :num
      t.string :label

      t.timestamps
    end
  end
end
