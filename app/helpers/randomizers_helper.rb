# frozen_string_literal: true

module RandomizersHelper
  DND_ARTWORKS = %w[dragon wizard battle moon_bats].freeze

  def random_card_artwork
    DND_ARTWORKS.sample
  end

  def random_artwork_position
    rand(1..5)
  end
end
