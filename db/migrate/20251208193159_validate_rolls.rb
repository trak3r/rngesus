class ValidateRolls < ActiveRecord::Migration[8.1]
  def change
    change_column_null :rolls, :user_id, false
    change_column_null :rolls, :slug, false
  end
end
