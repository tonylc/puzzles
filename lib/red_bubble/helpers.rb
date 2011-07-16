# straight copied from rails
class String #:nodoc:
  def blank?
    self !~ /\S/
  end
end
