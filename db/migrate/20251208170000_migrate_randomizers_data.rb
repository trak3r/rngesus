# frozen_string_literal: true

class MigrateRandomizersData < ActiveRecord::Migration[8.1]
  class Randomizer < ActiveRecord::Base; end

  class Roll < ActiveRecord::Base
    include Discard::Model
  end

  class RollTag < ActiveRecord::Base; end
  class Vote < ActiveRecord::Base; end

  class Tag < ActiveRecord::Base
    has_many :randomizer_tags
    has_many :randomizers, through: :randomizer_tags
  end

  class RandomizerTag < ActiveRecord::Base
    belongs_to :randomizer
    belongs_to :tag
  end

  # Re-open Randomizer to add associations for the migration
  class Randomizer < ActiveRecord::Base
    has_many :randomizer_tags
    has_many :tags, through: :randomizer_tags
    belongs_to :user
  end

  class User < ActiveRecord::Base; end

  def up
    # Safety check for environments where randomizers table is already gone
    return unless table_exists?(:randomizers)

    Rails.logger.debug 'Starting migration...'

    # rubocop:disable Metrics/BlockLength
    Randomizer.find_each do |randomizer|
      Rails.logger.debug { "Processing Randomizer: #{randomizer.name} (ID: #{randomizer.id})" }

      # Helper to get all rolls but prioritize kept ones for slug inheritance
      # Using local Roll class
      kept_rolls = Roll.where(randomizer_id: randomizer.id).kept.order(:created_at)
      discarded_rolls = Roll.where(randomizer_id: randomizer.id).discarded.order(:created_at)

      rolls = kept_rolls.to_a + discarded_rolls.to_a

      rolls.each_with_index do |roll, index|
        # Prepare attributes for update_columns
        attrs = { user_id: randomizer.user_id }

        if index.zero?
          attrs[:name] = randomizer.name
          # Primary Roll: Inherit slug and votes
          attrs[:slug] = randomizer.slug
          attrs[:cached_votes_total] = randomizer.cached_votes_total
          attrs[:cached_votes_score] = randomizer.cached_votes_score
          attrs[:cached_votes_up] = randomizer.cached_votes_up
          attrs[:cached_votes_down] = randomizer.cached_votes_down

          # Move Votes
          Vote.where(votable_type: 'Randomizer', votable_id: randomizer.id)
              .update_all(votable_type: 'Roll', votable_id: roll.id) # rubocop:disable Rails/SkipsModelValidations

          Rails.logger.debug { "  - Primary Roll (ID: #{roll.id}): Inheriting slug '#{randomizer.slug}'." }
        else
          # Generate new slug
          new_slug = nil
          loop do
            new_slug = SecureRandom.alphanumeric(5)
            # Check against local Roll class
            break unless Roll.exists?(slug: new_slug) && new_slug != randomizer.slug
          end
          attrs[:slug] = new_slug
          Rails.logger.debug { "  - Secondary Roll (ID: #{roll.id}): Generated new slug '#{new_slug}'." }
        end

        # Bypass validations and readonly checks
        roll.update_columns(attrs) # rubocop:disable Rails/SkipsModelValidations

        # Copy tags
        randomizer.tags.each do |tag|
          RollTag.find_or_create_by!(roll_id: roll.id, tag_id: tag.id)
        end

        Rails.logger.debug { "  - Processed Roll #{roll.id}" }
      end
    end
    # rubocop:enable Metrics/BlockLength
    Rails.logger.debug 'Migration complete!'
  end

  def down
    # Data migration usually doesn't need a down method as it moves data forward
  end
end
