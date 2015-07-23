require 'kramdown/document'
require 'kramdown/parser/kramdown'
require 'simplabs/highlight'

class Kramdown::Parser::ReadmeIOKramdown < Kramdown::Parser::Kramdown

  def initialize(source, options)
    super
    @span_parsers.unshift(:readme_io_tags)
  end

  def parse_readme_io_tags
    block = @src[1]
    content = JSON.parse(@src[2])
    @src.pos += @src.matched_size
    case block
    when 'api-header'
      @tree.children << Element.new(:header, nil, { }, { raw_text: content['title'], level: 1 })
      @tree.children.last.children << Element.new(:text, content['title'])
    when 'code'
      @tree.children << Element.new(:html_element, 'pre')
      code = Simplabs::Highlight.highlight(:ruby, content['codes'][0]['code'])
      @tree.children.last.children << Element.new(:raw, code)
    when 'callout'
      callout = new_block_el(:html_element, 'div', { class: "alert alert-#{content['type']}" })
      callout.children << Element.new(:raw, Kramdown::Document.new(content['body']).to_html)
      @tree.children << callout
    when 'image'
      @tree.children << Element.new(:img, nil, { src: content['images'][0]['image'][0] }, { })
    when 'if'
      @tree.children << Element.new(:comment, "if #{content['condition']}")
    when 'endif'
      @tree.children << Element.new(:comment, '/if')
    when 'parameters'
      table = Element.new(:html_element, 'table', { class: 'table' })
      thead = Element.new(:html_element, 'thead')
      thead.children << Element.new(:html_element, 'tr')
      1.upto(content['cols']) do |col|
        thead.children.last.children << Element.new(:html_element, 'th')
        thead.children.last.children.last.children << Element.new(:raw, Kramdown::Document.new(content['data']["h-#{col - 1}"], input: 'ReadmeIOKramdown').to_html)
      end
      table.children << thead
      tbody = Element.new(:html_element, 'tbody')
      1.upto(content['rows']) do |row|
        tbody.children << Element.new(:html_element, 'tr')
        1.upto(content['cols']) do |col|
          tbody.children.last.children << Element.new(:html_element, 'td')
          tbody.children.last.children.last.children << Element.new(:raw, Kramdown::Document.new(content['data']["#{row - 1}-#{col - 1}"], input: 'ReadmeIOKramdown').to_html)
        end
      end
      table.children << tbody
      @tree.children << table
    else
      raise "Block not supported: #{block}"
    end
  end

  README_IO_TAGS_START = /\[block:(.+?)\](.+?)\[\/block\]/m
  define_parser(:readme_io_tags, README_IO_TAGS_START)
end
