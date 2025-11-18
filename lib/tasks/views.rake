namespace :views do
  desc "Lint ERB and reformat HTML/ERB"
  task :format do
    sh "erb_lint app/views"

    require 'htmlbeautifier'
    require 'find'

    Find.find('app/views') do |path|
      next unless path =~ /\.erb$/
      content = File.read(path)
      beautified = HtmlBeautifier.beautify(content, indent: 2)
      File.write(path, beautified)
    end
  end
end

