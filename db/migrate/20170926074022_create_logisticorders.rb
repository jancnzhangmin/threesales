class CreateLogisticorders < ActiveRecord::Migration[5.0]
  def change
    create_table :logisticorders do |t|
      t.integer :logistic_id
      t.integer :buycar_id
      t.string :ordernumber

      t.timestamps
    end
  end
end
