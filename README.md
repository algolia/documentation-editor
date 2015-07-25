# Documentation Editor

This is the mountable Rails app providing the documentation editor of Algolia.com

It depends on:

 * Angular.js & ng-file-upload.js
 * Bootstrap 3
 * Fontawesome 4

## Installation

To use it in your own Rails project, do the following steps:

 * Mount the provided routes adding the following `Engine` to your `config/routes.rb` file:

```ruby
Rails.application.routes.draw do
  #
  # [ ... ]
  #
  mount DocumentationEditor::Engine => "/doc"
end
```

 * Add the following dependency in your `application.js`:

```js
// Make sure you've required `jquery`, `angular` and `ng-file-upload` before
//
//= require documentation_editor/pages
```

 * Add the following dependency in your `application.css`:

 ```css
/*
 * Make sure you've required `bootstrap` before
 *
 *= require documentation_editor/pages
 */
 ```

 * Go to `/doc/admin` to create your first page

## Configuration

Create a `config/initializers/documentation_editor.rb` file to configure the editor:

```ruby
# to use a custom layout
DocumentationEditor::Config.layout = 'my_layout'

# to protect the access to the edition pages to admin
DocumentationEditor::Config.is_admin_before_filter = :method_checking_if_admin

# to use custom options for paperclip
DocumentationEditor::Config.paperclip_options = {
  storage: 's3',
  s3_credentials: { bucket: 'xxx', access_key_id: 'xxx', secret_access_key: 'xxx' },
  s3_host_alias: 'xxxxxxxxxx.cloudfront.net',
  url: ':s3_alias_url',
  path: ':attachment/:id/:style.:extension'
}
```

## Development

```sh
$ bundle install
$ cd test/dummy
$ rake documentation_editor:install:migrations
$ rake db:migrate
$ rails server
$ open http://localhost:3000/doc/admin
```
