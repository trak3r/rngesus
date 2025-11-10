require "rtesseract"
require "mini_magick"
require "tempfile"

namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    # Rails-friendly absolute path
    image_path = Rails.root.join("test", "ocr", "forest_encounters_p154.png")
    puts "🔍 Processing #{image_path}..."

    # Load and preprocess the image
    img = MiniMagick::Image.open(image_path.to_s)
    img.colorspace "Gray"
    img.resize "200%"        # make text bigger for OCR
    img.contrast
    img.sharpen "0x1"        # enhance edges
    img.combine_options do |c|
      c.background "white"
      c.flatten
    end

    # Use Tempfile for safe temporary file handling
    Tempfile.create([ "processed", ".png" ]) do |f|
      img.write(f.path)

      # Configure RTesseract
      ocr = RTesseract.new(
        f.path,
        lang: "eng",
        psm: 6,  # treat as a single uniform block of text
        oem: 3   # LSTM OCR engine
      )

      text = ocr.to_s

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
end
