# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','do','version.rb'])
Gem::Specification.new do |s|
  s.name = 'do'
  s.version = Do::VERSION
  s.author = 'Benjamin Ortiz'
  s.email = 'hello.ben.ortiz@gmail.com'
  s.homepage = 'github.com/benortiz/do'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command line tool for logging activity'
  s.description = ''
  s.license = 'MIT'
  s.files = Dir.glob("{bin,lib}/**/*")
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'doing'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '>= 3.8'
  s.add_runtime_dependency 'gli', '~> 2.17', '>= 2.17.1'
  s.add_runtime_dependency('chronic','~> 0.10', '>= 0.10.2')
  s.add_runtime_dependency 'deep_merge', '~> 0'
  s.add_runtime_dependency 'ostruct', '~> 0'
end
