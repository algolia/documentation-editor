require 'test_helper'

module DocumentationEditor
  class RevisionTest < ActiveSupport::TestCase
    test "TOC generation" do
      r = build(:md_headers)
      toc = r.to_toc
      assert_equal 2, toc.size

      assert_equal 'this is a title', toc[0][:label]
      assert_equal 1, toc[0][:level]
      assert_equal 1, toc[0][:children].size

      assert_equal 'this is a subtitle', toc[0][:children][0][:label]
      assert_equal 2, toc[0][:children][0][:level]
      assert_equal 0, toc[0][:children][0][:children].size

      assert_equal 'this is another title', toc[1][:label]
      assert_equal 1, toc[1][:level]
      assert_equal 2, toc[1][:children].size

      assert_equal 'first subtitle', toc[1][:children][0][:label]
      assert_equal 2, toc[1][:children][0][:level]
      assert_equal 0, toc[1][:children][0][:children].size

      assert_equal 'second subtitle', toc[1][:children][1][:label]
      assert_equal 2, toc[1][:children][1][:level]
      assert_equal 0, toc[1][:children][1][:children].size
    end

    test "TOC id generations" do
      toc = build(:md_headers).to_toc
      assert_equal 'this-is-a-title', toc[0][:id]
    end

    test "TOC duplicated ids" do
      toc = build(:md_duplicated_headers).to_toc
      assert_equal 'this-is-a-title', toc[0][:id]
      assert_equal 'this-is-a-title-1', toc[1][:id]
    end

    test "simple HTML generation" do
      html = build(:md_headers).to_html
      assert html.include?('<h1 id="this-is-a-title"><a href="#this-is-a-title" class="anchor"><i class="fa fa-link"></i></a>this is a title</h1>')
      assert html.include?('<h2 id="this-is-a-subtitle"><a href="#this-is-a-subtitle" class="anchor"><i class="fa fa-link"></i></a>this is a subtitle</h2>')
      assert html.include?('<h1 id="this-is-another-title"><a href="#this-is-another-title" class="anchor"><i class="fa fa-link"></i></a>this is another title</h1>')
      assert html.include?('<h2 id="first-subtitle"><a href="#first-subtitle" class="anchor"><i class="fa fa-link"></i></a>first subtitle</h2>')
      assert html.include?('<h2 id="second-subtitle"><a href="#second-subtitle" class="anchor"><i class="fa fa-link"></i></a>second subtitle</h2>')
    end

    test "single-tab code block" do
      html = build(:md_code_block).to_html
      assert !html.include?('data-toggle="tab"')
      assert html.include?('<pre><span class="c1">// this is javascript code</span></pre>')
    end

    test "language-specific code block" do
      html = build(:md_code_block).to_html(language: 'js')
      assert html.include?('<pre><span class="c1">// this is javascript code</span></pre>')
      assert !html.include?('<li')
    end

    test "language-specific code block with *" do
      html = build(:md_code_block_star).to_html(language: 'ruby')
      assert html.include?('<pre><span class="c1">// this is javascript code</span></pre>')
      assert !html.include?('<li')
    end

    test "callout block" do
      html = build(:md_info_callout_block).to_html
      assert html.include?('<div class="alert alert-info">')
    end

    test "image block" do
      html = build(:md_image_block).to_html
      assert html.include?('<figure><img src="https://example.org/image.png" />')
      assert html.include?('<figcaption><p>Searchable Attributes &amp; Record Popularity</p>')
    end

    test "if block" do
      html_python = build(:md_if_block).to_html(language: 'python')
      html_ruby = build(:md_if_block).to_html(language: 'ruby')
      assert !html_python.include?('This is only visible in ruby')
      assert html_ruby.include?('This is only visible in ruby')
    end

    test "ifnot block" do
      html_python = build(:md_ifnot_block).to_html(language: 'python')
      html_ruby = build(:md_ifnot_block).to_html(language: 'ruby')
      assert html_python.include?('This is not visible in ruby')
      assert !html_ruby.include?('This is not visible in ruby')
    end

    test "parameters block" do
      html = build(:md_parameters_block).to_html
      assert html.include?('<th><p>Name</p>')
      assert html.include?('<th><p>Type</p>')
      assert html.include?('<th><p>Description</p>')
      assert html.include?('<td id="param-a-name"><p>a name')
      assert html.include?('<td><p>a type')
      assert html.include?('<td><p>a description')
    end

    test "variable block" do
      html = build(:md_variable_block).to_html(variables: { a_variable: 'foo' })
      assert html.include?('<p>This is a variable foo.</p>')
    end

    test "buttons block" do
      html = build(:md_buttons_block).to_html
      assert html.include?('<a href="first list" class="btn btn-default">1st button</a>')
      assert html.include?('<a href="second link" class="btn btn-default">2nd button</a>')
    end

  end
end
