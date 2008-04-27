require 'rubygems'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'

Gem::manage_gems
include FileUtils

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	s.required_ruby_version = '>= 1.8.6'
	s.name = "autocode"
	s.version = "0.9.3"
	s.authors = ["Dan Yoder", "Matthew King"]
	s.homepage = 'http://dev.zeraweb.com/'
	s.add_dependency 'metaid'
	s.summary	= "Utility for auto-including, reloading, and generating classes and modules."
	s.files = Dir['*/**/*']
	s.bindir = 'bin'
	s.executables = []
	s.require_path = "lib"
	s.has_rdoc = true
end

task :package => :clean do 
	Gem::Builder.new(spec).build
end

task :clean do
	system 'rm -rf *.gem'
end

task :install => :package do
	system 'sudo gem install ./*.gem'
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add([ 'README', 'lib/*.rb' ])
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/*.rb"].exclude("test/helpers.rb", "test_lib/**/*
")
  t.verbose = true
end