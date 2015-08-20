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
      h1 = nil
      doc = parse_document(options.merge(no_wrap: true))
      ids = id_generator(doc)
      doc.root.children.each do |child|
        next if child.type != :header
        text = child.options[:raw_text]
        text = resolve_variables(options, text)
        id = ids.generate_id(text)
        h1 = id if child.options[:level] == 1
        item = { label: text, id: id, children: [], level: child.options[:level], h1: h1 }
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
      doc = Kramdown::Document.new(content, options.merge(input: 'BlockKramdown'))

      # apply the /if filtering
      doc.root.children = apply_filtering(doc.root.children, options, [])

      # wrap in sections
      if !options[:no_wrap] && DocumentationEditor::Config.wrap_h1_with_sections
        sections = []
        current_section = []
        h1 = nil
        ids = id_generator(doc)
        keep = options[:section].nil?
        doc.root.children.each do |child|
          if child.type == :header && child.options[:level] == 1 && !current_section.select { |c| c.type != :blank }.empty?
            sections << current_section if keep
            current_section = []
            keep = options[:section].nil? || options[:section] == ids.generate_id(resolve_variables(options, child.options[:raw_text]))
          end
          current_section << child
        end
        if !current_section.select { |c| c.type != :blank }.empty? && keep
          sections << current_section
        end
        doc.root.children = sections.map do |nested_sections|
          section = Kramdown::Element.new(:html_element, 'section')
          section.children = nested_sections
          section
        end
      end

      doc
    end

    def apply_filtering(children, options, conditions_stack)
      children.map do |child|
        if child.type == :comment
          if child.options[:start] == true
            all = (child.options[:condition] || '').split(/[, ]+/)
            pass = !all.detect { |condition| options[:language] == condition }.nil?
            pass = !pass if child.options[:negation]
            conditions_stack << pass
            nil
          elsif child.options[:start] == false
            conditions_stack.pop
            nil
          else
            conditions_stack.last == false ? nil : child
          end
        else
          res = conditions_stack.last == false ? nil : child
          child.children = apply_filtering(child.children, options, conditions_stack)
          res
        end
      end.compact
    end

    def id_generator(doc)
       Kramdown::Converter::Html.send(:new, doc.root, {auto_id_prefix: ''})
    end

    def resolve_variables(options, text)
      variables = ActiveSupport::HashWithIndifferentAccess.new(options[:variables] || {})
      text.gsub(/\[\[ *variable:(.+?) *\]\]/) do |m|
        ERB::Util.html_escape(variables[$1] || 'FIXME')
      end
    end

  end
end
