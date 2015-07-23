module DocumentationEditor
  class Page < ActiveRecord::Base

    def to_html
      document.to_html
    end

    private
    def document
      @document ||= Kramdown::Document.new(content, :input => 'ReadmeIOKramdown')
    end

  end
end
