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
end
