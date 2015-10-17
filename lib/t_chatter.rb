require "t_chatter/version"
# gem 'faraday'
require 'json'
require 'faraday'
require 'yaml'
require 'singleton'

module TChatter
  # Your code goes here...
end

Object.class_eval do
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end


APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('lib', 't_chatter', '*.rb')].each { |f| require f }
