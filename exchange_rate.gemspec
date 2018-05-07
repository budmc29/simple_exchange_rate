# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exchange_rate/version'

Gem::Specification.new do |spec|
  spec.name          = 'exchange_rate'
  spec.version       = ExchangeRate::VERSION
  spec.authors       = ['budmc29']
  spec.email         = ['chirica.mugurel@gmail.com']

  spec.summary       = %q{Exchange Rate}
  spec.description   = %q{An exercise take on a simple exchange rate library}
  spec.homepage      = 'http://mugur-chirica.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency('nokogiri', '>= 1.8.2')
end
