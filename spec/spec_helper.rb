$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'bundler/setup'

# They say at the very top, but realistically bundler has to be loaded in order for Ruby to find simplecov. ;)
require 'simplecov'
SimpleCov.start

require 'chatcraft'

RSpec.configure do |c|
end

