# frozen_string_literal: true

class BetterTagVariety < ActiveRecord::Migration[8.1]
  def change
    %i[
      consumable
      downtime
      effect
      event
      location
      loot
      npc
      plot
      weather
    ].each do |tag_name|
      Tag.create!(name: tag_name.to_s.titleize)
    end
    Tag.find(1).update(name: 'Wilderness')
    Tag.find(2).update(name: 'Urban')
  end
end
