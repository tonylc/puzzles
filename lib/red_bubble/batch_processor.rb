require 'rubygems'
require 'nokogiri'
require 'erubis'

if ARGV.size != 2
  p "Usage: ruby batch_processor.rb <input_file> <output_directory>"
  exit
end

# straight copied from rails
class String #:nodoc:
  def blank?
    self !~ /\S/
  end
end

module Works
  def first_ten_works
    @works.compact.slice(0, 10)
  end
end

class BatchProcess
  include Works

  def initialize
    @make_hash = {}
    @works = []
  end

  def parse_work(work_obj)
    make_name = work_obj.css('exif make').text
    model_name = work_obj.css('exif model').text
    uri = work_obj.css('urls url:first').text

    uri = uri.blank? ? nil : uri
    @works << uri

    add_work(make_name, model_name, uri) unless make_name.blank?
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
    @models_hash = {}
    @works = []
  end

  def add_work(model_name, uri)
    if !model_name.nil?
      if @models_hash[model_name].nil?
        @models_hash[model_name] = Model.new(@name, model_name)
      end
      @models_hash[model_name].add_work(uri)
    end
    @works << uri
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

  def add_work(uri)
    @works << uri
  end
end

input_file = ARGV.first
output_dir = ARGV.last
process = BatchProcess.new
doc = Nokogiri::XML(File.open(input_file))

doc.css('work').each do |work|
  process.parse_work(work)
end

File.open("#{output_dir}/index.html", 'w') do |f|
  eruby = Erubis::Eruby.new(File.read('index_template.eruby'))
  f.write(eruby.result(:makes => process.makes, :thumbnails => process.first_ten_works))
end

process.makes.each do |make|
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
