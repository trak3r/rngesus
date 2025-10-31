class CreateRolls < ActiveRecord::Migration[8.1]
  def change
    create_table :rolls do |t|
      t.integer :value
      t.references :randomizer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
