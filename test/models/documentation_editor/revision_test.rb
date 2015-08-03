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

  end
end
