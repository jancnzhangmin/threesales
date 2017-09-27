class CreateLogistics < ActiveRecord::Migration[5.0]
  def change
    create_table :logistics do |t|
      t.string :logistic

      t.timestamps
    end
  end
end
