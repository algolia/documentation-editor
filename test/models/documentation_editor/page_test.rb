require 'test_helper'

module DocumentationEditor
  class PageTest < ActiveSupport::TestCase

    test "add a non-published revision" do
      page = build(:doc)
      assert_equal 0, page.revisions.count
      page.save
      assert_equal 1, page.revisions.count
      page.add_revision!('sample content')
      assert_equal 2, page.revisions.count
      assert_equal nil, page.published_revision_id
    end

    test "add a published revision" do
      page = build(:doc)
      r = page.add_revision!('sample content', true)
      assert_equal r.id, page.published_revision_id
    end
  end
end
