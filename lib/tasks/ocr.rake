namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    image_file = Rails.root.join(
      "test",
      "ocr",
      "forest_encounters_p154.png"
    )

    raw = RollTableOcr.new(image_file).to_s

    # Parse a 2-column table:
    #   first column = range,
    #   second column = full remaining content
    rows = raw.lines.map(&:strip).reject(&:empty?)
    data = rows.drop(1).map do |line|
      range, text = line.split(/\s+/, 2)  # split into exactly 2 parts
      min = range.split('-').first
      { range: range, min: min, text: text }
    end

    puts "\n🎲 Parsed rolls:"
    data.each { |row| puts "#{row[:min]} => #{row[:text]}" }
  end
end
