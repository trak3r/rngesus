# frozen_string_literal: true

namespace :ocr do
  desc 'Parse a dice roll table image'
  task test: :environment do
    image_file = Rails.root.join(
      'test/ocr/forest_encounters_p154.png'
    )

    array = RollTableOcr.new(image_file).to_a

    puts(CSV.generate { |csv| array.each { |row| csv << row } })
  end
end
