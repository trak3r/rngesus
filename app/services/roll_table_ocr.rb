class RollTableOcr
  attr :image_file

  def initialize(image_file)
    @image_file = image_file
  end

  def to_s
    @to_s ||= process
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
end
