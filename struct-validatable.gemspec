require File.expand_path('../lib/struct/validatable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.summary       = %q{Struct will have flexible validators for each member.}
  gem.description   = %q{Struct will have flexible validators for each member.}
  gem.homepage      = 'https://github.com/kachick/struct-validatable'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{|f| File.basename f}
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'struct-validatable'
  gem.require_paths = ['lib']
  gem.version       = Struct::Validatable::VERSION.dup # dup for https://github.com/rubygems/rubygems/commit/48f1d869510dcd325d6566df7d0147a086905380#-P0

  gem.required_ruby_version = '>= 1.9.2'
 
  gem.add_runtime_dependency 'validation', '~> 0.0.3'

  gem.add_development_dependency 'struct-alias_member', '~> 0.0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end

