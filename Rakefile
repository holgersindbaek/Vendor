# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require './lib/Vendor'

require 'bundler'
Bundler.require

require 'sugarcube-color'
require 'sugarcube-repl'
require "awesome_print_motion"
# require 'bacon/colored_output'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Vendor'
  app.frameworks << "StoreKit"

  app.pods do
    pod 'CocoaSecurity', '~> 1.2.1'
    pod 'AFNetworking', '~> 1.0'
  end

  app.codesign_certificate = "iPhone Developer: holger sindbæk (553BRGV25S)"
  app.provisioning_profile = "Vendor_Test_App.mobileprovision"

  app.info_plist['UIStatusBarHidden'] = true
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] =  false
end
