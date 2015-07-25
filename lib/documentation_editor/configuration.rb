module DocumentationEditor
  class Configuration
    # custom layout
    attr_accessor :layout

    # configure the before_filter to use to identity administrators
    attr_accessor :is_admin_before_filter

    # additional paperclip parameters
    attr_accessor :paperclip_options

    # should we wrap h1's content by sections
    attr_accessor :wrap_h1_with_sections
  end
end
