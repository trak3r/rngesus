class RollTableOcr
  attr :image_file

  def initialize(image_file)
    @image_file = image_file
  end

  def to_s
    @to_s ||= process
  end

  def to_a
    @to_a ||= parse
  end

  private

    def process
      img = MiniMagick::Image.open(image_file.to_s)
      img.colorspace "Gray"
      img.resize "200%"        # make text bigger for OCR
      img.contrast
      img.sharpen "0x1"        # enhance edges
      img.combine_options do |c|
        c.background "white"
        c.flatten
      end

      Tempfile.create([ "processed", ".png" ]) do |f|
        img.write(f.path)

        ocr = RTesseract.new(
          f.path,
          lang: "eng",
          psm: 6,  # treat as a single uniform block of text
          oem: 3   # LSTM OCR engine
        )

        text = ocr.to_s
      end
    end

    def parse
      # Parse a 2-column table:
      #   first column = range,
      #   second column = full remaining content
      rows = to_s.lines.map(&:strip).reject(&:empty?)
    data = rows.drop(1).map do |line|
      range, text = line.split(/\s+/, 2)  # split into exactly 2 parts
      min = range.split("-").first
      # { min: min, text: text }
      [ min, text ]
    end
    end
end
