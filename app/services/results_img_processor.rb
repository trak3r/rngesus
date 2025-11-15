# frozen_string_literal: true

class ResultsImgProcessor
  attr_reader :roll, :image_file

  def initialize(roll, image_file)
    @roll = roll
    @image_file = image_file
  end

  def to_s
    @to_s ||= begin
      img = MiniMagick::Image.open(@image_file)
      img.colorspace 'Gray'
      img.resize '200%'        # make text bigger for OCR
      img.contrast
      img.sharpen '0x1'        # enhance edges
      img.combine_options do |c|
        c.background 'white'
        c.flatten
      end

      Tempfile.create(['processed', '.png']) do |f|
        img.write(f.path)

        ocr = RTesseract.new(
          f.path,
          lang: 'eng',
          psm: 6,  # treat as a single uniform block of text
          oem: 3   # LSTM OCR engine
        )

        ocr.to_s
      end
    end
  end

  def to_a
    @to_a ||= to_s.split("\n")
  end

  def parsed_list
    @parsed_list ||= begin
      # Parse a 2-column table:
      #   first column = range,
      #   second column = description
      #   third+ column(s) discard
      rows = to_a # s.lines.map(&:strip).reject(&:empty?)

      # range will be ...
      #   a lone number (1)
      #   sometimes zero prefixed (01)
      #   two hyphenated numbers (3-6)
      #   sometimes a number suffixed with a plus sign (14+)
      rows.map do |line|
        # Split the line into columns; allow extra columns beyond the first two
        cols = line.split(/\s+/)
        range = cols[0]
        text  = cols[1..].join(' ') # rest of line as text

        next if text.empty?

        next if range.blank?

        # Extract minimum number from range
        min_str = range.split('-').first
        min_str = min_str.gsub(/^0+/, '').gsub(/\+$/, '') # remove leading zeros & trailing '+'

        # Skip if min is invalid or zero
        next if min_str.empty? || min_str.to_i.zero?

        [min_str.to_i, text.strip]
      end.compact
    end
  end

  def call
    parsed_list.each do |line|
      value = line[0]
      name  = line[1]
      roll.results.create(value: value, name: name)
    end
  end
end
