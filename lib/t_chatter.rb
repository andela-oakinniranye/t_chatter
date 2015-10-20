require "t_chatter/version"

require 'json'
require 'faraday'
require 'yaml'
require 'singleton'
require 'uri'
require 'securerandom'
require 'pathname'

module TChatter
  DEFAULT_URL = "http://tchatter.herokuapp.com"
  UNIQUE_ID = SecureRandom.uuid.gsub('-', '')
  # Your code goes here...
end

Object.class_eval do
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('lib', 't_chatter', '*.rb')].each { |f| require f }
