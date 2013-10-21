# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require './lib/Vendor'

require 'bundler'
Bundler.require

require 'sugarcube-color'
require 'sugarcube-repl'
require "awesome_print_motion"
require 'guard/motion'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Vendor'

  app.identifier = "com.holgersindbaek.vendor"
  app.codesign_certificate = "iPhone Developer: holger sindbæk (553BRGV25S)"
  app.provisioning_profile = "Vendor_Test_App.mobileprovision"

  app.info_plist['UIStatusBarHidden'] = true
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] =  false
end