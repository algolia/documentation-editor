$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "documentation_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "documentation-editor"
  s.version     = DocumentationEditor::VERSION
  s.authors     = ["Algolia Team"]
  s.email       = ["support@algolia.com"]
  s.homepage    = "https://github.com/algolia/documentation-editor"
  s.summary     = "Mountable Rails application providing an extended Markdown documentation editor."
  s.description = "The goal of this project is to provide an easy & frictionless way to edit an online tech documentation. The sweet spot of this editor is to be able to generate pages containing multiple snippets of highlighted code & conditional sections (which wasn't really available in any other CMS we considered). It also includes a nice image uploader storing the image to Amazon S3, a simple table editor and an automatic table of content generator."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.0"
  s.add_dependency "haml-rails"
  s.add_dependency "kramdown"
  s.add_dependency "highlight"
  s.add_dependency "sass-rails"
  s.add_dependency "paperclip", "~> 4.3"
  s.add_dependency "diffy"
  s.add_dependency "best_in_place"
end
