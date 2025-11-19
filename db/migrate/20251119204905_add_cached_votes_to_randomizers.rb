class AddCachedVotesToRandomizers < ActiveRecord::Migration[8.1]
  def change
    add_column :randomizers, :cached_votes_total, :integer, default: 0
    add_column :randomizers, :cached_votes_score, :integer, default: 0
    add_column :randomizers, :cached_votes_up, :integer, default: 0
    add_column :randomizers, :cached_votes_down, :integer, default: 0
  end
end
