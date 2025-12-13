# frozen_string_literal: true

class BetterTagVariety < ActiveRecord::Migration[8.1]
  def change
    %i[
      consumable
      downtime
      effect
      encounter
      event
      location
      loot
      npc
      plot
      urban
      weather
    ].each do |tag_name|
      Tag.create!(name: tag_name.titleize)
    end
    Tag.find(1).update(name: 'Wilderness')
  end
end
