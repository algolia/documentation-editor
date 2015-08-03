$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "documentation_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "documentation_editor"
  s.version     = DocumentationEditor::VERSION
  s.authors     = ["Algolia Team"]
  s.email       = ["support@algolia.com"]
  s.homepage    = "https://github.com/algolia/AlgoliaDocumentationEditor"
  s.summary     = "Markdown documentation editor"
  s.description = "Markdown documentation editor"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.0"
  s.add_dependency "haml-rails"
  s.add_dependency "kramdown"
  s.add_dependency "highlight"
  s.add_dependency "sass-rails"
  s.add_dependency "paperclip", "~> 4.3"
  s.add_dependency "diffy"
end
