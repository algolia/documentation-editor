require 'test_helper'

module DocumentationEditor
  class RevisionTest < ActiveSupport::TestCase
    test "TOC generation" do
      r = build(:markdown_headers)
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
      toc = build(:markdown_headers).to_toc
      assert_equal 'this-is-a-title', toc[0][:id]
    end

    test "TOC duplicated ids" do
      toc = build(:duplicated_headers).to_toc
      assert_equal 'this-is-a-title', toc[0][:id]
      assert_equal 'this-is-a-title-1', toc[1][:id]
    end

    test "simple HTML generation" do
      html = build(:markdown_headers).to_html
      assert html.include?('<h1 id="this-is-a-title"><a href="#this-is-a-title" class="anchor"><i class="fa fa-link"></i></a>this is a title</h1>')
      assert html.include?('<h2 id="this-is-a-subtitle"><a href="#this-is-a-subtitle" class="anchor"><i class="fa fa-link"></i></a>this is a subtitle</h2>')
      assert html.include?('<h1 id="this-is-another-title"><a href="#this-is-another-title" class="anchor"><i class="fa fa-link"></i></a>this is another title</h1>')
      assert html.include?('<h2 id="first-subtitle"><a href="#first-subtitle" class="anchor"><i class="fa fa-link"></i></a>first subtitle</h2>')
      assert html.include?('<h2 id="second-subtitle"><a href="#second-subtitle" class="anchor"><i class="fa fa-link"></i></a>second subtitle</h2>')
    end

    test "code block" do
      skip
    end

    test "callout block" do
      html = build(:info_callout).to_html
      assert html.include?('<div class="alert alert-info"><p>This is a valuable info.</p>')
    end

    test "image block" do
      skip
    end

    test "if block" do
      skip
    end

    test "ifnot block" do
      skip
    end

    test "parameters block" do
      skip
    end

  end
end
