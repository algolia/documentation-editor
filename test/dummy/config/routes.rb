Rails.application.routes.draw do

  mount DocumentationEditor::Engine => "/doc"
end
