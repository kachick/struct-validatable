# coding: us-ascii

require File.expand_path('../lib/struct/validatable/version', __FILE__)

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Struct will have validators for each member.}
  gem.summary       = gem.description.dup
  gem.homepage      = 'http://kachick.github.com/struct-validatable'
  gem.license       = 'MIT'

  gem.name          = 'struct-validatable'
  gem.version       = Struct::Validatable::VERSION.dup

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_runtime_dependency 'validation', '~> 0.0.7'
  gem.add_development_dependency 'test-unit', '>= 2.5.5', '< 2.6'
  gem.add_development_dependency 'struct-alias_member', '~> 0.0.3'
  gem.add_development_dependency 'yard', '>= 0.8.7.3', '< 0.9'
  gem.add_development_dependency 'rake', '>= 10', '< 20'
  gem.add_development_dependency 'bundler', '>= 1.3.5', '< 2'

  if RUBY_ENGINE == 'rbx'
    gem.add_dependency 'rubysl', '~> 2.0'
  end

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end

