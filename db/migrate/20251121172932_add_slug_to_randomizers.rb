class AddSlugToRandomizers < ActiveRecord::Migration[8.1]
  def up
    # Add the slug column (nullable initially for backfill)
    add_column :randomizers, :slug, :string, limit: 5
    add_index :randomizers, :slug, unique: true

    # Backfill slugs for existing randomizers
    Randomizer.reset_column_information
    Randomizer.find_each do |randomizer|
      loop do
        slug = generate_slug
        begin
          randomizer.update_column(:slug, slug)
          break
        rescue ActiveRecord::RecordNotUnique
          # Collision detected, try again
          next
        end
      end
    end

    # Now make it non-nullable
    change_column_null :randomizers, :slug, false
  end

  def down
    remove_column :randomizers, :slug
  end

  private

  def generate_slug
    SecureRandom.alphanumeric(5)
  end
end
