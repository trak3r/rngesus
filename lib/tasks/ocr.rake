require "rtesseract"
require "mini_magick"
require "tempfile"

namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    image_path = "./test/ocr/forest_encounters_p154.png"

    puts "🔍 Processing #{image_path}..."

    # Load and preprocess the image
    img = MiniMagick::Image.open(image_path)
    img.colorspace "Gray"
    img.resize "200%"       # Make text bigger for OCR
    img.contrast
    img.sharpen "0x1"       # Enhance edges
    img.combine_options do |c|
      c.background "white"
      c.flatten
    end

    # Use Tempfile so we don't leave processed images around
    Tempfile.create(["processed", ".png"]) do |f|
      img.write(f.path)

      # Configure RTesseract
      ocr = RTesseract.new(
        f.path,
        lang: "eng",
        psm: 6,   # Treat as a single uniform block of text
        oem: 3    # LSTM OCR engine
      )

      text = ocr.to_s

      puts "📜 Raw OCR output:\n\n#{text}"

      # Very basic parsing example for a 2-column table
      rows = text.lines.map(&:strip).reject(&:empty?)
      data = rows.drop(1).map do |line|
        parts = line.split(/\s+/)
        { range: parts[0], result: parts[1] }
      end

      puts "\n🎲 Parsed rolls:"
      data.each { |row| puts "#{row[:range]} => #{row[:result]}" }
    end
  end
end

