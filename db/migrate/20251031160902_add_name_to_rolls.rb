class AddNameToRolls < ActiveRecord::Migration[8.1]
  def change
    add_column :rolls, :name, :string
  end
end
