namespace :ocr do
  desc "Parse a dice roll table image"
  task test: :environment do
    image_file = Rails.root.join(
      "test",
      "ocr",
      "forest_encounters_p154.png"
    )

    ap RollTableOcr.new(image_file).to_a
  end
end
