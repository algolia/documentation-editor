FactoryGirl.define do
  factory :doc, class: DocumentationEditor::Page do
    slug 'guide'
  end

  factory :md_headers, class: DocumentationEditor::Revision do
    content <<-EOF
# this is a title

## this is a subtitle

# this is another title

## first subtitle

## second subtitle
EOF
  end

  factory :md_duplicated_headers, class: DocumentationEditor::Revision do
    content <<-EOF
# this is a title

# this is a title
EOF
  end

  factory :md_info_callout_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:callout]
{
  "type": "info",
  "body": "This is a valuable info."
}
[/block]
EOF
  end

  factory :md_image_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:image]
{
  "images": [
    {
      "image": ["https://example.org/image.png"]
    }
  ],
  "caption": "Searchable Attributes & Record Popularity"
}
[/block]
EOF
  end

  factory :md_image_without_caption_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:image]
{
  "images": [
    {
      "image": ["https://example.org/image.png"]
    }
  ]
}
[/block]
EOF
  end

  factory :md_code_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:code]
{
  "codes": [
    {
      "language":"js",
      "code": "// this is javascript code"
    }
  ]
}
[/block]
EOF
  end

  factory :md_code_block_star, class: DocumentationEditor::Revision do
    content <<-EOF
[block:code]
{
  "codes": [
    {
      "language":"js|*",
      "code": "// this is javascript code"
    }
  ]
}
[/block]
EOF
  end

  factory :md_if_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:if]
{
  "condition": "ruby"
}
[/block]
This is only visible in ruby
[block:endif]
{
}
[/block]
EOF
  end

  factory :md_ifnot_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:ifnot]
{
  "condition": "ruby"
}
[/block]
This is not visible in ruby
[block:endif]
{
}
[/block]
EOF
  end

  factory :md_parameters_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:parameters]
{
  "data": {
    "h-0": "Name",
    "h-1": "Type",
    "h-2": "Description",
    "0-0": "a name",
    "0-1": "a type",
    "0-2": "a description"
  },
  "cols": 3,
  "rows": 2
}
[/block]
EOF
  end

  factory :md_variable_block, class: DocumentationEditor::Revision do
    content <<-EOF
This is a variable [[variable:a_variable]].
EOF
  end

  factory :md_buttons_block, class: DocumentationEditor::Revision do
    content <<-EOF
[block:buttons]
{
  "buttons": [
    { "label": "1st button", "link": "first list" },
    { "label": "2nd button", "link": "second link" }
  ]
}
[/block]
EOF
  end

end
