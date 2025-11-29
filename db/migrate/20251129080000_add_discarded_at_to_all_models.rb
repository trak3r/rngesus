# frozen_string_literal: true

class AddDiscardedAtToAllModels < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :discarded_at, :datetime
    add_index :users, :discarded_at

    add_column :randomizers, :discarded_at, :datetime
    add_index :randomizers, :discarded_at

    add_column :rolls, :discarded_at, :datetime
    add_index :rolls, :discarded_at

    add_column :results, :discarded_at, :datetime
    add_index :results, :discarded_at

    add_column :tags, :discarded_at, :datetime
    add_index :tags, :discarded_at
  end
end
