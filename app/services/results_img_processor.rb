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

  # Parse a 2-column table:
  #   first column = range,
  #   second column = description
  #   third+ column(s) discard
  # range will be ...
  #   a lone number (1)
  #   sometimes zero prefixed (01)
  #   two hyphenated numbers (3-6)
  #   sometimes a number suffixed with a plus sign (14+)
  def parsed_list
    @parsed_list ||= begin
      rows = to_a # original OCR lines, stripped
      result = []
      last_row = nil

      rows.each do |line|
        line = line.strip
        next if line.empty?

        cols = line.split(/\s+/)
        first_col = cols[0]

        # Remove any trailing period, comma, or colon from the first column
        clean_col = first_col.gsub(/[.,:]$/, '')

        # Handle common OCR substitutions for numbers
        clean_col = clean_col.gsub(/[lIT]/, '1').tr('O', '0').tr('S', '5')

        if /^\d+(-\d+)?\+?$/.match?(clean_col) # line starts with a number/range
          # Extract minimum number from range
          min_str = clean_col.split('-').first
          min_str = min_str.gsub(/^0+/, '').gsub(/\+$/, '') # remove leading zeros & trailing '+'

          next if min_str.empty? || min_str.to_i.zero?

          # Rest of line as text
          text = (cols[1..] || []).join(' ').strip
          next if text.empty?

          row = [min_str.to_i, text]
          result << row
          last_row = row
        elsif last_row
          # continuation line: append to last row's text if available
          last_row[1] += " #{line}"
        end
      end

      result
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
