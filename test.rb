require 'html/proofer'
require 'html/pipeline'
require 'fileutils'

EXPORT_DIR = './out'

# make an out dir
Dir.mkdir(EXPORT_DIR) unless File.exists?(EXPORT_DIR)

pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::TableOfContentsFilter
], :gfm => true

# iterate over files, and generate HTML from Markdown
Dir.glob('**/*.md') do |path|
  contents = File.read(path)
  result = pipeline.call(contents)

  output_path = path.split('/').pop.sub('.md', '.html')
  File.open("#{EXPORT_DIR}/#{output_path}", 'w') { |file| file.write(result[:output].to_s) }
end

# test your out dir!
HTML::Proofer.new(EXPORT_DIR).run

FileUtils.rm_rf(EXPORT_DIR)
