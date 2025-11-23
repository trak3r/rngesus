# frozen_string_literal: true

class ConvertRandomizersTagsToRandomizerTags < ActiveRecord::Migration[8.1]
  def change
    rename_table :randomizers_tags, :randomizer_tags
    add_column :randomizer_tags, :id, :primary_key
  end
end
