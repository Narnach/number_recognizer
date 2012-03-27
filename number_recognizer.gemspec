Gem::Specification.new do |s|
  # Project
  s.name         = 'number_recognizer'
  s.summary      = "NumberRecognizer is library to recognize mobile phone numbers. It can make educated guesses to correct local numbers into numbers in international format."
  s.description  = s.summary
  s.version      = '1.0.0'
  s.date         = '2012-03-27'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Wes Oldenbeuving"]
  s.email        = "narnach@me.com"
  s.homepage     = "http://www.github.com/narnach/number_recognizer"

  # Files
  root_files     = %w[Readme.md number_recognizer.gemspec MIT-LICENSE]
  bin_files      = []
  lib_files      = %w[number_recognizer number_recognizer/format_dsl]
  s.bindir       = "bin"
  s.require_path = "lib"
  s.executables  = bin_files
  s.test_files   = %w[number_recognizer].map{|f| "spec/#{f}_spec.rb"}
  s.files        = root_files + s.test_files + bin_files.map {|f| 'bin/%s' % f} + lib_files.map {|f| 'lib/%s.rb' % f} + %w[spec/spec_helper.rb]

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ Readme.md]
  s.rdoc_options << '--inline-source' << '--line-numbers' << '--main' << 'Readme.md'

  # Requirements
  s.required_ruby_version = ">= 1.8.0"
end
