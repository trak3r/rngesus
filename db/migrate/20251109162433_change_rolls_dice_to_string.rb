class ChangeRollsDiceToString < ActiveRecord::Migration[8.1]
  def change
    remove_column :rolls, :dice
    add_column :rolls, :dice, :string
  end
end
