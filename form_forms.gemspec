# -*- encoding: utf-8 -*-
require File.expand_path('../lib/form_forms/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Holger Just"]
  gem.email         = ["hjust@meine-er.de"]
  gem.description   = %q{Configurable forms for Rails}
  gem.summary       = %q{Configurable forms for Rails}
  gem.homepage      = "https://github.com/meineerde/form_forms"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "form_forms"
  gem.require_paths = ["lib"]
  gem.version       = Formforms::VERSION

  gem.add_dependency "activesupport", "~> 3.0"
  gem.add_dependency "actionpack", "~> 3.0"
  gem.add_dependency "simple_form"

  gem.add_development_dependency "activemodel", "~> 3.0"
end
