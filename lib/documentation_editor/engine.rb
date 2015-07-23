module DocumentationEditor
  class Engine < ::Rails::Engine
    isolate_namespace DocumentationEditor

    initializer 'documentation_editor.configuration', :before => :load_config_initializers do |app|
      app.config.documentation_editor = DocumentationEditor::Configuration.new
      DocumentationEditor::Config = app.config.documentation_editor
    end
  end
end
