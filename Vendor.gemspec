# -*- encoding: utf-8 -*-
VENDOR_VERSION = "0.3.1"

Gem::Specification.new do |spec|
  spec.name          = "rm_vendor"
  spec.version       = VENDOR_VERSION
  spec.authors       = ["Holger Sindbaek"]
  spec.email         = ["HolgerSindbaek@gmail.com"]
  spec.description   = %q{A RubyMotion StoreKit Wrapper that allows you to buy, restore and get product info on your in app purchases and subscriptions}
  spec.summary       = %q{RubyMotion StoreKit Wrapper}
  spec.homepage      = "https://github.com/holgersindbaek/Vendor"
  spec.license       = "MIT"
  
  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_dependency "motion-cocoapods"
  spec.add_dependency "sugarcube"
  spec.add_dependency "bubble-wrap"
end