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

end
