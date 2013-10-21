# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'motion', :env => {:output => 'colored_spec_dox'}, :all_after_pass => false  do
  watch(%r{^spec/.+_spec\.rb$})

  # RubyMotion App example
  watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }

  # RubyMotion gem example
  watch(%r{^lib/[^/]+/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end
