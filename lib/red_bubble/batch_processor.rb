require 'rubygems'
require 'nokogiri'
require 'erubis'
require 'helpers'

if ARGV.size != 2
  p "Usage: ruby batch_processor.rb <input_file> <output_directory>"
  exit
end

input_file = ARGV.first
output_dir = ARGV.last

f = File.open(input_file)
doc = Nokogiri::XML(f)
f.close

makes_hash = models_hash = {}
makes_array = models_array = []

doc.css('work').each do |work|
  make_tag = work.css('exif make').to_s
  model_tag = work.css('exif model').to_s
  small_url = work.css('urls url:first').to_s
  if !make_tag.blank?
    make_tag = strip_tags('make', make_tag)
    makes_hash[make_tag] = [] if makes_hash[make_tag].nil?
    makes_hash[make_tag] << (small_url.blank? ? nil : strip_tags('url', small_url))
    makes_array << make_tag
  end
  if !model_tag.blank?
    model_tag = strip_tags('model', model_tag)
    models_hash[model_tag] = [] if models_hash[model_tag].nil?
    models_hash[model_tag] << (small_url.blank? ? nil : strip_tags('url', small_url))
    models_array << model_tag
  end
end

makes_array.uniq!
models_array.uniq!

File.open("#{output_dir}/index.html", 'w') do |f|
  eruby = Erubis::Eruby.new(File.read('index_template.eruby'))
  f.write(eruby.result(:title => 'Photos', :items => makes_array, :thumbnails => []))
end

makes_array.each do |make_name|
  File.open("#{output_dir}/#{make_name}.html", 'w') do |f|
    eruby = Erubis::Eruby.new(File.read('make_template.eruby'))
    f.write(eruby.result(:title => 'Makes', :items => models_array, :thumbnails => makes_hash[make_name]))
  end
end

models_array.each do |model_name|
  File.open("#{output_dir}/#{model_name}.html", 'w') do |f|
    eruby = Erubis::Eruby.new(File.read('model_template.eruby'))
    f.write(eruby.result(:title => 'Models', :items => [], :thumbnails => models_hash[model_name]))
  end
end
