module DocumentationEditor
  class Page < ActiveRecord::Base

    def to_html(options = {})
      html = parse_document(options).to_html
      # apply the /if filtering keeping only the matching conditions
      conditions = (options[:condition] || '').split(/[, ]+/)
      html.gsub(/<!-- ((?!#{conditions.join('|')}).)*? -->.*?<!-- \/((?!#{conditions.join('|')}).)*? -->/m, '')
    end

    def to_toc(options = {})
      roots = []
      levels = []
      doc = parse_document(options)
      doc.root.children.each do |child|
        next if child.type != :header
        item = { label: child.options[:raw_text], id: generate_id(doc, child.options[:raw_text]), children: [], level: child.options[:level] }
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
      conditions = (options[:condition] || '').split(/[, ]+/)
      conditions_stack = []
      doc.root.children = doc.root.children.map do |child|
        if child.type == :comment || (child.type == :p && child.children.length == 1 && child.children[0].type == :comment)
          comment = child.type == :comment ? child : child.children[0]
          if comment.options[:start] == true
            all = (comment.options[:condition] || '').split(/[, ]+/)
            pass = all.select { |condition| conditions.include?(condition) }.size == all.size
            conditions_stack << pass
            nil
          elsif comment.options[:start] == false
            conditions_stack.pop
            nil
          else
            conditions_stack.last == false ? nil : child
          end
        else
          conditions_stack.last == false ? nil : child
        end
      end.compact

      doc
    end

    def generate_id(doc, str)
      @html_converter ||= Kramdown::Converter::Html.send(:new, doc.root, {auto_id_prefix: ''})
      @html_converter.generate_id(str)
    end

  end
end
