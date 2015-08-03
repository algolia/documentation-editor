module DocumentationEditor
  class Engine < ::Rails::Engine
    isolate_namespace DocumentationEditor

    initializer 'documentation_editor.configuration', :before => :load_config_initializers do |app|
      app.config.documentation_editor = DocumentationEditor::Configuration.new
      DocumentationEditor::Config = app.config.documentation_editor
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end
  end
end
