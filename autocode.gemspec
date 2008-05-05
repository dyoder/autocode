Gem::Specification.new do |s|
  s.name = %q{autocode}
  s.version = "0.9.4"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-04-30}
  s.files = ["lib/autocode.rb", "lib/reloadable.rb", "test/autocreate.rb", "test/autoinit.rb", "test/autoload.rb", "test/helpers.rb", "test/test_lib", "test/test_lib/critter.rb", "test/test_lib/doo_dad.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Utility for auto-including, reloading, and generating classes and modules.}

  s.add_dependency(%q<metaid>, [">= 0"])
end
