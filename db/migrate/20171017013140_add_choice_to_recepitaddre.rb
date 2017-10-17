class AddChoiceToRecepitaddre < ActiveRecord::Migration[5.0]
  def change
    add_column :recepitaddres, :choice, :integer
  end
end
