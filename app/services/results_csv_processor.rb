class ResultsCsvProcessor
  attr_reader :roll, :file

  def initialize(roll, file)
    @roll = roll
    @file = file
  end

  def call
    CSV.foreach(file.path, headers: false) do |line|
      value = line[0]
      name  = line[1]
      roll.results.create(value: value, name: name)
    end
  end
end
