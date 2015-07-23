module DocumentationEditor
  class Page < ActiveRecord::Base

    def to_html
      document.to_html
    end

    def to_menu
      roots = []
      levels = []
      document.root.children.each do |child|
        next if child.type != :header
        item = { label: child.options[:raw_text], id: generate_id(child.options[:raw_text]), children: [], level: child.options[:level] }
        while !levels.empty? && levels.last[:level] >= child.options[:level]
          levels.pop
        end
        if levels.empty?
          roots << item
        else
          levels.last[:children] << item
        end
        levels << item
      end
      roots
    end

    private
    def document
      @document ||= Kramdown::Document.new(content, :input => 'ReadmeIOKramdown')
    end

    def generate_id(str)
      @html_converter ||= Kramdown::Converter::Html.send(:new, document.root, {auto_id_prefix: ''})
      @html_converter.generate_id(str)
    end

  end
end
