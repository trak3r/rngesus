# frozen_string_literal: true

class ReplaceTagsWithGenericNames < ActiveRecord::Migration[8.0]
  def up
    # Delete all existing tags (and associated randomizer_tags via dependent: :destroy)
    Tag.destroy_all

    # Create new generic D&D-themed tags
    %w[Forest Town Dungeon Treasure Magic Encounter].each do |tag_name|
      Tag.create!(name: tag_name)
    end
  end

  def down
    # Remove the generic tags
    Tag.where(name: %w[Forest Town Dungeon Treasure Magic Encounter]).destroy_all
  end
end
