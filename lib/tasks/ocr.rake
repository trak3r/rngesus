require "rtesseract"
require "mini_magick"

namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    image_path = ARGV[1] || "./test/ocr/forest_encounters_p154.png"

    puts "🔍 Processing #{image_path}..."

    # Optional preprocessing for better OCR accuracy
    img = MiniMagick::Image.open(image_path)
    img.colorspace "Gray"
    img.contrast
    img.threshold "60%"
    img.write("tmp/processed.png")

    ocr = RTesseract.new("tmp/processed.png")
    text = ocr.to_s

    puts "📜 Raw OCR output:\n\n#{text}"

    # Very basic parsing example
    rows = text.lines.map(&:strip).reject(&:empty?)
    data = rows.drop(1).map do |line|
      parts = line.split(/\s+/)
      { player: parts[0], dice: parts[1], result: parts[2] }
    end

    puts "\n🎲 Parsed rolls:"
    data.each { |row| puts "#{row[:player]} rolled #{row[:dice]} = #{row[:result]}" }
  end
end

