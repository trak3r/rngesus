class RemoveValueFromRolls < ActiveRecord::Migration[8.1]
  def change
    # Remove the integer value column from rolls. Use if_exists for safety.
    remove_column :rolls, :value, :integer, if_exists: true
  end
end
