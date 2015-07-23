$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "documentation_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "documentation_editor"
  s.version     = DocumentationEditor::VERSION
  s.authors     = ["Sylvain UTARD"]
  s.email       = ["sylvain.utard@gmail.com"]
  s.homepage    = "https://www.algolia.com"
  s.summary     = "Markdown documentation editor"
  s.description = "Markdown documentation editor"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.0"
  s.add_dependency "haml-rails"
  s.add_dependency "kramdown"
  s.add_dependency "highlight"
  s.add_dependency "simple_form"
  s.add_dependency "sass-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "angularjs-rails"
  s.add_development_dependency "less-rails-bootstrap"
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "therubyracer"
  s.add_development_dependency "font-awesome-rails"
end
