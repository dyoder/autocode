# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{autocode}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder", "Matthew King", "Lawrence Pitt"]
  s.date = %q{2009-01-08}
  s.email = %q{dan@zeraweb.com}
  s.files = ["lib/autocode.rb", "test/auto_create.rb", "test/auto_eval.rb", "test/auto_load.rb", "test/auto_module.rb", "test/helpers.rb", "test/least_surprise.rb", "test/normalize.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{autocode}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Utility for auto-including, reloading, and generating classes and modules.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
