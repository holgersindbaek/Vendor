# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require './lib/Vendor'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Vendor'
  app.frameworks << "StoreKit"

  app.pods do
    pod 'CocoaSecurity', '~> 1.2.1'
    pod 'AFNetworking', '~> 1.0'
  end
end