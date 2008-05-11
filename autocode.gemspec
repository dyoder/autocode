Gem::Specification.new do |s|
  s.name = %q{autocode}
  s.version = "0.9.8"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-05-09}
  s.files = ["lib/autocode.rb", "test/autocreate.rb", "test/autoinit.rb", "test/autoload.rb", "test/helpers.rb", "test/test_lib", "test/test_lib/answer42_it_is.rb", "test/test_lib/critter.rb", "test/test_lib/doo_dad.rb", "test/test_lib/humbug.rb", "test/test_lib/the_class42_gang.rb", "test/test_lib/the_one_and_only_class.rb", "test/test_lib/the_one_and_only_module.rb", "test/test_lib/the_pretender.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Utility for auto-including, reloading, and generating classes and modules.}

  s.add_dependency(%q<metaid>, [">= 0"])
end
