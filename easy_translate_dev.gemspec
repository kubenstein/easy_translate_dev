# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "easy_translate_dev/version"

Gem::Specification.new do |s|
  s.name        = "easy_translate_dev"
  s.version     = EasyTranslateDev::VERSION
  s.authors     = ["kubenstein"]
  s.email       = ["kubenstein@gmail.com"]
  s.homepage    = "https://github.com/kubenstein/easy_translate_dev"
  s.summary     = %q{EasyTranslateDev is a hack that allows you not to pay for translations using EasyTranslate gem}
  s.description = %q{EasyTranslateDev use google spreadsheet document to make translations}

  s.rubyforge_project = "easy_translate_dev"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "google_drive"
end
