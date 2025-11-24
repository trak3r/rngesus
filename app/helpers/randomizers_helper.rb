# frozen_string_literal: true

module RandomizersHelper
  DND_ARTWORKS = %w[dragon wizard dungeon warrior].freeze

  def random_dnd_artwork
    DND_ARTWORKS.sample
  end

  def random_artwork_position
    rand(1..5)
  end
end
