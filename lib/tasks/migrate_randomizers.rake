namespace :data do
  desc "Migrate Randomizers to Rolls"
  task migrate_randomizers_to_rolls: :environment do
    puts "Starting migration..."
    ActiveRecord::Base.transaction do
      Randomizer.find_each do |randomizer|
        puts "Processing Randomizer: #{randomizer.name} (ID: #{randomizer.id})"
        
        # Helper to get all rolls but prioritize kept ones for slug inheritance
        kept_rolls = Roll.where(randomizer_id: randomizer.id).kept.order(:created_at)
        discarded_rolls = Roll.where(randomizer_id: randomizer.id).discarded.order(:created_at)
        
        rolls = kept_rolls.to_a + discarded_rolls.to_a
        
        rolls.each_with_index do |roll, index|
          
          # Prepare attributes for update_columns
          attrs = { user_id: randomizer.user.id }
          
          if index == 0
            # Primary Roll: Inherit slug and votes
            attrs[:slug] = randomizer.slug
            attrs[:cached_votes_total] = randomizer.cached_votes_total
            attrs[:cached_votes_score] = randomizer.cached_votes_score
            attrs[:cached_votes_up] = randomizer.cached_votes_up
            attrs[:cached_votes_down] = randomizer.cached_votes_down
            
            # Move Votes
            randomizer.votes_for.update_all(votable_type: 'Roll', votable_id: roll.id)
            
            puts "  - Primary Roll (ID: #{roll.id}): Inheriting slug '#{randomizer.slug}'."
          else
            # Generate new slug
            new_slug = nil
            loop do
              new_slug = SecureRandom.alphanumeric(5)
              break unless Roll.exists?(slug: new_slug) && new_slug != randomizer.slug # Check against randomizer slug too just in case? No, Roll.exists? covers it if we migrated.
            end
            attrs[:slug] = new_slug
            puts "  - Secondary Roll (ID: #{roll.id}): Generated new slug '#{new_slug}'."
          end
          
          # Bypass validations and readonly checks
          roll.update_columns(attrs)
          
          # Copy tags
          randomizer.tags.each do |tag|
            RollTag.find_or_create_by!(roll: roll, tag: tag)
          end
          
          puts "  - Processed Roll #{roll.id}"
        end
      end
    end
    puts "Migration complete!"
  end
end
