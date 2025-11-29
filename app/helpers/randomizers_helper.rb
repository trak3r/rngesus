# frozen_string_literal: true

module RandomizersHelper
  DND_ARTWORKS = %w[
    dragon
    wizard
    battle
    moon_bats
    castle_road
  ].freeze

  def random_card_artwork
    DND_ARTWORKS.sample
  end

  def random_artwork_position
    rand(3..7)
  end

  def toggle_tag_url(tag_name, current_tags: nil)
    current_tags ||= Array(params[:tags])

    new_tags = if current_tags.include?(tag_name)
                 current_tags - [tag_name]
               else
                 current_tags + [tag_name]
               end

    randomizers_path(tab: params[:tab], query: params[:query], tags: new_tags)
  end

  def tag_active?(tag_name, current_tags: nil)
    current_tags ||= Array(params[:tags])
    current_tags.include?(tag_name)
  end
end
