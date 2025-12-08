class EnhanceRolls < ActiveRecord::Migration[8.1]
  def change
    add_reference :rolls, :user, foreign_key: true
    add_column :rolls, :slug, :string, limit: 5
    add_index :rolls, :slug, unique: true

    add_column :rolls, :cached_votes_total, :integer, default: 0
    add_column :rolls, :cached_votes_score, :integer, default: 0
    add_column :rolls, :cached_votes_up, :integer, default: 0
    add_column :rolls, :cached_votes_down, :integer, default: 0

    create_table :roll_tags do |t|
      t.references :roll, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.index [:roll_id, :tag_id], unique: true
    end
  end
end
