# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-medpass/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Karol Sarnacki']
  gem.email         = ['sodercober@gmail.com']
  gem.description   = %q{Medpass OpenID Strategy for OmniAuth 1.0}
  gem.summary       = %q{Medpass OpenID Strategy for OmniAuth 1.0}
  gem.homepage      = 'https://github.com/connectmedica/omniauth-medpass'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-medpass'
  gem.require_paths = ['lib']
  gem.version       = Omniauth::Medpass::VERSION

  gem.add_runtime_dependency 'omniauth-openid', '~> 1.0.0'

  gem.add_development_dependency 'rspec', '~> 2.8.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
end
