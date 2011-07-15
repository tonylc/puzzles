# straight copied from rails
class String #:nodoc:
  def blank?
    self !~ /\S/
  end
end

def strip_tags(pattern, text)
  regex = Regexp.new("\<#{pattern}[^>]*\>(.*)\<\/#{pattern}\>")
  regex.match(text)[1]
end
