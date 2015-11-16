require 'kramdown/document'
require 'kramdown/parser/kramdown'
require 'simplabs/highlight'
require 'htmlentities'

class Kramdown::Parser::BlockKramdown < Kramdown::Parser::Kramdown

  def initialize(source, options)
    @language = options[:language] || options['language']
    super
    @span_parsers.unshift(:block_tags)
  end

  def parse_block_tags
    block = @src[1]
    content = JSON.parse(@src[2])
    @src.pos += @src.matched_size
    case block
    when 'code'
      if @language
        code = content['codes'].detect { |code| code['language'] == @language || code['language'].end_with?("|#{@language}") }
        code ||= content['codes'].detect { |code| code['language'].end_with?("|*") }
        @tree.children << Element.new(:html_element, 'pre')
        @tree.children.last.children << Element.new(:raw, code ? highlight(code['language'].split('|').first, code['code']) : "FIXME:#{@language}")
      elsif content['codes'].size == 1
        code = content['codes'].first
        @tree.children << Element.new(:html_element, 'pre')
        @tree.children.last.children << Element.new(:raw, highlight(code['language'].split('|').first, code['code']))
      else
        ul = Element.new(:html_element, 'ul', { class: 'nav nav-tabs' })
        tab_content = Element.new(:html_element, 'div', { class: 'tab-content' })
        content['codes'].each_with_index do |v, i|
          language, label = v['language'].split('|')
          label ||= language
          id = "snippet_#{@src.pos}_#{generate_id(v['language'])}"
          ul.children << Element.new(:html_element, 'li', { class: ('active' if i == 0) })
          ul.children.last.children << Element.new(:html_element, 'a', { href: "##{id}", 'data-toggle' => 'tab' })
          ul.children.last.children.last.children << Element.new(:raw, label)
          tab_content.children << Element.new(:html_element, 'pre', { class: "tab-pane#{' in active' if i == 0}", id: id })
          tab_content.children.last.children << Element.new(:raw, highlight(language, v['code']))
        end
        @tree.children << ul
        @tree.children << tab_content
      end
    when 'callout'
      callout = new_block_el(:html_element, 'div', { class: "alert alert-#{content['type']}" })
      callout.children << Element.new(:raw, parse_cached(content['body']))
      @tree.children << callout
    when 'html'
      coder = HTMLEntities.new
      @tree.children << Element.new(:raw, coder.decode(content['body']))
    when 'image'
      clazz = case content['float']
      when 'left'
        'pull-left'
      when 'right'
        'pull-right'
      else
        nil
      end
      attrs = { src: content['images'][0]['image'][0] }
      if !content['width'].blank?
        attrs[:width] = content['width'].to_i
      end
      @tree.children << Element.new(:html_element, 'figure', { class: clazz })
      @tree.children.last.children << Element.new(:img, nil, attrs)
      unless content['caption'].blank?
        @tree.children.last.children << Element.new(:html_element, 'figcaption')
        @tree.children.last.children.last.children << Element.new(:raw, parse_cached(content['caption']))
      end
    when 'buttons'
      buttons = new_block_el(:html_element, 'div', { class: "text-center" })
      content['buttons'].each do |b|
        buttons.children << Element.new(:html_element, 'a', { href: b['link'], class: 'btn btn-default' })
        buttons.children.last.children << Element.new(:raw, b['label'])
      end
      @tree.children << buttons
    when 'if'
      @tree.children << Element.new(:comment, "if #{content['condition']}", { }, { start: true, condition: content['condition'], negation: false })
    when 'ifnot'
      @tree.children << Element.new(:comment, "if NOT #{content['condition']}", { }, { start: true, condition: content['condition'], negation: true })
    when 'endif'
      @tree.children << Element.new(:comment, '/if', { }, { start: false, condition: content['condition'] })
    when 'parameters'
      table = Element.new(:html_element, 'table', { class: 'table' })
      thead = Element.new(:html_element, 'thead')
      thead.children << Element.new(:html_element, 'tr')
      1.upto(content['cols']) do |col|
        thead.children.last.children << Element.new(:html_element, 'th')
        thead.children.last.children.last.children << Element.new(:raw, parse_cached(content['data']["h-#{col - 1}"]))
      end
      table.children << thead
      tbody = Element.new(:html_element, 'tbody')
      1.upto(content['rows']) do |row|
        tbody.children << Element.new(:html_element, 'tr')
        1.upto(content['cols']) do |col|
          md = content['data']["#{row - 1}-#{col - 1}"]
          id = generate_id("param #{md}")
          anchor = col == 1 ? "\n<a href=\"##{id}\" class=\"anchor\"><i class=\"fa fa-link\"></i></a>" : ''
          html = parse_cached("#{md}#{anchor}")
          tbody.children.last.children << Element.new(:html_element, 'td', col == 1 ? { id: id } : nil)
          tbody.children.last.children.last.children << Element.new(:raw, html)
        end
      end
      table.children << tbody
      @tree.children << table
    else
      raise "Block not supported: #{block}"
    end
  end

  BLOCK_TAGS_START = /\[block:(.+?)\](.+?)\[\/block\]/m
  define_parser(:block_tags, BLOCK_TAGS_START)

  private
  def generate_id(str)
    id = (str || '').gsub(/<\/?[^>]+>/, '').strip.gsub(/[^a-zA-Z0-9]+/, '-')
    @ids ||= {}
    @ids[id] ||= 0
    @ids[id] += 1
    @ids[id] == 1 ? id : "#{id}-#{@ids[id]}"
  end

  def cache(key, &block)
    if !Rails.cache.exist?(key)
      html = yield
      Rails.cache.write(key, html)
    end
    Rails.cache.read(key)
  end

  def highlight(language, code)
    language = language.to_s.downcase
    language = case language
    when 'php', 'swift', 'node', 'node.js'
      'js'
    when 'android'
      'java'
    when 'go'
      'c++'
    else
      language
    end
    cache "#{language}_#{code.hash}" do
      Simplabs::Highlight.highlight(language, CGI.unescapeHTML(code))
    end
  end

  def parse_cached(text)
    cache "#{text.hash}" do
      Kramdown::Document.new(text, input: 'BlockKramdown').to_html
    end
  end
end
