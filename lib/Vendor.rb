require 'rubygems'
require 'bubble-wrap/core'
require 'sugarcube-anonymous'
require 'sugarcube-legacy'
require 'motion-cocoapods'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

lib_dir_path = File.dirname(File.expand_path(__FILE__))
Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(lib_dir_path, "project/**/*.rb")))

  app.pods ||= Motion::Project::CocoaPods.new(app)
  app.pods.pod 'CocoaSecurity', '~> 1.2.1'
  app.pods.pod 'AFNetworking', '~> 1.0'
end