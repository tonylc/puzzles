require 'rubygems'
#require 'spork'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

# Spork.prefork do
#   # Loading more in this block will cause your tests to run faster. However,
#   # if you change any configuration or code from libraries loaded here, you'll
#   # need to restart spork for it take effect.
# end
#
# Spork.each_run do
#   # This code will be run each time you run your specs.
#
# end
