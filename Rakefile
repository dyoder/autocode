%w{ rubygems date rake/rdoctask rake/testtask fileutils }.each do |dep|
  require dep
end

Gem::manage_gems
include FileUtils

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.6'
  s.name = "autocode"
  s.rubyforge_project = 'autocode'
  s.version = "1.0.1"
  s.authors = ["Dan Yoder", "Matthew King", "Lawrence Pitt"]
  s.email = 'dan@zeraweb.com'
  s.homepage = 'http://dev.zeraweb.com/'
  s.summary  = "Utility for auto-including, reloading, and generating classes and modules."
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

desc "create .gemspec file (useful for github)"
task :gemspec do
  filename = "#{spec.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts spec.to_ruby
  end
end

desc 'Publish rdoc to RubyForge.'
task :publish do
  # `rsync -avz --delete doc/rdoc/ dyoder67@rubyforge.org:/var/www/gforge-projects/autocode/`
  `scp -r doc/rdoc dyoder67@rubyforge.org:/var/www/gforge-projects/autocode/`
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add([ 'README', 'HISTORY', 'lib/*.rb' ])
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/*.rb"].exclude("test/helpers.rb")
  t.verbose = true
end
