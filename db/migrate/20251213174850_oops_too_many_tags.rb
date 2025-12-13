# frozen_string_literal: true

class OopsTooManyTags < ActiveRecord::Migration[8.1]
  def change
    Tag.where(name: 'Npc').update(name: 'NPC')
    Tag.where(name: %w[Effect Event Loot]).destroy_all
  end
end
