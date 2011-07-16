require 'rubygems'
require 'nokogiri'
require 'erubis'
require 'helpers'

if ARGV.size != 2
  p "Usage: ruby batch_processor.rb <input_file> <output_directory>"
  exit
end

module Works
  def first_ten_works
    @works.compact.slice(0, 10)
  end
end

class AllMakes
  def initialize
    @make_hash = {}
  end

  def add_work(make_name, model_name, thumb_src)
    if @make_hash[make_name].nil?
      @make_hash[make_name] = Make.new(make_name)
    end
    @make_hash[make_name].add_work(model_name, thumb_src)
  end

  def makes
    @makes ||= @make_hash.values.uniq
  end
end

class Make
  include Works
  attr_reader :name

  def initialize(make_name)
    @name = make_name
    @works = []
    @models_hash = {}
  end

  def add_work(model_name, thumb_src)
    if @models_hash[model_name].nil?
      @models_hash[model_name] = Model.new(@name, model_name)
    end
    @models_hash[model_name].add_work(thumb_src)
    @works << thumb_src
  end

  def models
    @models ||= @models_hash.values.uniq
  end
end

class Model
  include Works
  attr_reader :name, :make_name

  def initialize(make_name, model_name)
    @make_name = make_name
    @name = model_name
    @works = []
  end

  def add_work(thumb_src)
    @works << thumb_src
  end
end

input_file = ARGV.first
output_dir = ARGV.last

f = File.open(input_file)
doc = Nokogiri::XML(f)
f.close

all_makes = AllMakes.new
all_works = []

doc.css('work').each do |work|
  make_tag = work.css('exif make').to_s
  model_tag = work.css('exif model').to_s
  uri = work.css('urls url:first').to_s
  uri = uri.blank? ? nil : strip_tags('url', uri)
  all_works << uri

  if !make_tag.blank? && !model_tag.blank?
    all_makes.add_work(strip_tags('make', make_tag), strip_tags('model', model_tag), uri)
  end
end

File.open("#{output_dir}/index.html", 'w') do |f|
  eruby = Erubis::Eruby.new(File.read('index_template.eruby'))
  f.write(eruby.result(:makes => all_makes.makes, :thumbnails => all_works.compact.slice(0,10)))
end

all_makes.makes.each do |make|
  File.open("#{output_dir}/#{make.name}.html", 'w') do |f|
    eruby = Erubis::Eruby.new(File.read('make_template.eruby'))
    f.write(eruby.result(:make => make))
  end

  make.models.each do |model|
    File.open("#{output_dir}/#{model.name}.html", 'w') do |f|
      eruby = Erubis::Eruby.new(File.read('model_template.eruby'))
      f.write(eruby.result(:model => model))
    end
  end
end
