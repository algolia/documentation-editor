module DocumentationEditor
  class Revision < ActiveRecord::Base
    belongs_to :page

    def to_html(options = {})
      html = parse_document(options).to_html
      # resolve the variables
      html = resolve_variables(options, html)
      # resolve the code condition block
      html = html.gsub(/\[\[ *(.+?) *\]\](.+?)\[\[ *\/.+? *\]\]/m) do |m|
        options[:language] == $1 ? $2 : ''
      end
      # add anchor links before headers
      html.gsub(/<h[1-6] id="([^"]+)">/) { |m| "#{m}<a href=\"##{$1}\" class=\"anchor\"><i class=\"fa fa-link\"></i></a>"  }
    end

    def to_toc(options = {})
      roots = []
      levels = []
      doc = parse_document(options.merge(no_wrap: true))
      doc.root.children.each do |child|
        next if child.type != :header
        text = child.options[:raw_text]
        text = resolve_variables(options, text)
        item = { label: text, id: generate_id(doc, child.options[:raw_text]), children: [], level: child.options[:level] }
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
    def parse_document(options)
      doc = Kramdown::Document.new(content, options.merge(input: 'ReadmeIOKramdown'))

      # apply the /if filtering
      conditions_stack = []
      doc.root.children = doc.root.children.map do |child|
        if child.type == :comment || (child.type == :p && child.children.length == 1 && child.children[0].type == :comment)
          comment = child.type == :comment ? child : child.children[0]
          if comment.options[:start] == true
            all = (comment.options[:condition] || '').split(/[, ]+/)
            pass = !all.detect { |condition| options[:language] == condition }.nil?
            pass = !pass if comment.options[:negation]
            conditions_stack << pass
            nil
          elsif comment.options[:start] == false
            conditions_stack.pop
            nil
          else
            conditions_stack.last == false ? nil : child
          end
        else
          p child if conditions_stack.last == false
          conditions_stack.last == false ? nil : child
        end
      end.compact

      # wrap in sections
      if !options[:no_wrap] && DocumentationEditor::Config.wrap_h1_with_sections
        sections = []
        current_section = []
        doc.root.children.each do |child|
          if child.type == :header && child.options[:level] == 1 && !current_section.select { |c| c.type != :blank }.empty?
            sections << current_section
            current_section = []
          end
          current_section << child
        end
        sections << current_section unless current_section.select { |c| c.type != :blank }.empty?
        doc.root.children = sections.map do |nested_sections|
          section = Kramdown::Element.new(:html_element, 'section')
          section.children = nested_sections
          section
        end
      end

      doc
    end

    def generate_id(doc, str)
      @html_converter ||= Kramdown::Converter::Html.send(:new, doc.root, {auto_id_prefix: ''})
      @html_converter.generate_id(str)
    end

    def resolve_variables(options, text)
      variables = ActiveSupport::HashWithIndifferentAccess.new(options[:variables] || {})
      text.gsub(/\[\[ *variable:(.+?) *\]\]/) do |m|
        ERB::Util.html_escape(variables[$1] || 'FIXME')
      end
    end

  end
end
