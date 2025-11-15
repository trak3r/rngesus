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
    @to_a ||= begin
      # Parse a 2-column table:
      #   first column = range,
      #   second column = description
      #   third+ column(s) discard
      rows = to_s.lines.map(&:strip).reject(&:empty?)
      rows.map do |line|
        range, text, extra = line.split(/\s+/, 2) # split into exactly 2 parts
        # range will be ...
        #   a lone number (1)
        #   sometimes zero prefixed (01)
        #   two hyphenated numbers (3-6)
        #   sometimes a number suffixed with a plus sign (14+)
        min = range.split('-').first
        # FIXME: skip is we don't get a valid non-zero value for min
        [min, text]
      end
    end
  end

  def call
    to_a.each do |line|
      value = line[0]
      name  = line[1]
      roll.results.create(value: value, name: name)
    end
  end
end
