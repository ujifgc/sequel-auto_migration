# coding: utf-8
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'sequel/auto_migration/version'

Gem::Specification.new do |spec|
  spec.name          = 'sequel-auto_migration'
  spec.version       = Sequel::AutoMigrate::VERSION
  spec.description   = 'Basic auto migration for Sequel'
  spec.summary       = 'A gem to provide semi-automatic database migration'

  spec.authors       = ['Igor Bochkariov']
  spec.email         = ['ujifgc@gmail.com']
  spec.homepage      = 'https://github.com/ujifgc/sequel-auto_migration'
  spec.license       = 'MIT'

  spec.require_paths = ['lib']
  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^test/})

  spec.add_dependency 'sequel', '~> 3.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
