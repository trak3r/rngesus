require "rtesseract"
require "mini_magick"
require "tempfile"

namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    image_file = Rails.root.join(
      "test",
      "ocr",
      "forest_encounters_p154.png"
    )

    text = RollTableOcr.new(image_file).to_s

    puts "📜 Raw OCR output:\n\n#{text}"

    # Parse a 2-column table: first column = range, second column = full remaining content
    rows = text.lines.map(&:strip).reject(&:empty?)
    data = rows.drop(1).map do |line|
      parts = line.split(/\s+/, 2)  # split into exactly 2 parts
      { range: parts[0], result: parts[1] }
    end

    puts "\n🎲 Parsed rolls:"
    data.each { |row| puts "#{row[:range]} => #{row[:result]}" }
  end
end
