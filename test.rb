require 'html/proofer'
require 'html/pipeline'
require 'fileutils'

EXPORT_DIR = './out'

# make an out dir
Dir.mkdir(EXPORT_DIR) unless File.exists?(EXPORT_DIR)

pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::TableOfContentsFilter
], gfm: true

# iterate over files, and generate HTML from Markdown
Dir.glob('**/*.md') do |path|
  contents = File.read(path)
  result = pipeline.call(contents)

  output_file = path.sub(/\.md$/, '.html')
  output_path = File.dirname(output_file)
  FileUtils.mkdir_p("#{EXPORT_DIR}/#{output_path}")
  File.open("#{EXPORT_DIR}/#{output_file}", 'w') do |file|
    file.write(result[:output].to_s)
  end
end

# test your out dir!
HTML::Proofer.new(EXPORT_DIR).run

FileUtils.rm_rf(EXPORT_DIR)
