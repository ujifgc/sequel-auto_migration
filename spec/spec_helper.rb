require 'rubygems'
require 'sequel'
require 'sequel-auto_migration'

(defined?(RSpec) ? RSpec::Core::ExampleGroup : Spec::Example::ExampleGroup).class_eval do
  def meta_def(obj, name, &block)
    (class << obj; self end).send(:define_method, name, &block)
  end
end
