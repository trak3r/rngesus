class AddRollToResults < ActiveRecord::Migration[8.1]
  def change
    add_reference :results, :roll, null: false, foreign_key: true
  end
end
