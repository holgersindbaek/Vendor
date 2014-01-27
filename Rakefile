# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require './lib/Vendor'

require 'bundler'
Bundler.require

require 'sugarcube-color'
require 'sugarcube-repl'
require 'sugarcube-localized'
require 'awesome_print_motion'
require 'guard/motion'

Motion::Project::App.setup do |app|
  
  # Load environment variables from .env - described here: https://github.com/ainame/motion-my_env
  app.my_env.file = 'environment.yaml'
  
  # Load the variables into the config
  TEMP_ENV = YAML.load(File.open('environment.yaml'))

  # Use `rake config' to see complete project settings.
  app.name = 'Vendor'

  app.development do
    app.provisioning_profile = TEMP_ENV['DEV_PROVISIONING_PROFILE'] || "Vendor_Test_App.mobileprovision"
    app.identifier = TEMP_ENV['DEV_IDENTIFIER'] || "com.your.identifier"
    app.codesign_certificate = TEMP_ENV['DEV_CODESIGN_CERTIFICATE'] || "iPhone Developer: John Galt"
  end

  app.release do
    app.provisioning_profile = TEMP_ENV['DIS_PROVISIONING_PROFILE'] || "Vendor_Test_App.mobileprovision"
    app.identifier = TEMP_ENV['DIS_IDENTIFIER'] || "com.your.identifier"
    app.codesign_certificate = TEMP_ENV['DIS_CODESIGN_CERTIFICATE'] || "iPhone Developer: John Galt"
  end

  # Override identifier, so the ending doesn't have _spec in it (for spec'ing purposes)
  def app.identifier
    TEMP_ENV['DIS_IDENTIFIER'] || "com.your.identifier"
  end

  app.info_plist['UIStatusBarHidden'] = true
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] =  false
end