class AddDiceToRolls < ActiveRecord::Migration[8.1]
  def change
        add_column :rolls, :dice, :json, default: []
  end
end
