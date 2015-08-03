FactoryGirl.define do
  factory :doc, class: DocumentationEditor::Page do
    slug 'guide'
  end

  factory :markdown_headers, class: DocumentationEditor::Revision do
    content <<-EOF
# this is a title

## this is a subtitle

# this is another title

## first subtitle

## second subtitle
EOF
  end

  factory :duplicated_headers, class: DocumentationEditor::Revision do
    content <<-EOF
# this is a title

# this is a title
EOF
  end

  factory :info_callout, class: DocumentationEditor::Revision do
    content <<-EOF
[block:callout]
{
  "type": "info",
  "body": "This is a valuable info."
}
[/block]
EOF
  end

  factory :image, class: DocumentationEditor::Revision do
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
end
