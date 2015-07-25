# Documentation Editor

This is the mountable Rails app providing the documentation editor of Algolia.com

It depends on:

 * Angular.js
 * Bootstrap 3
 * Fontawesome 4

## Usage

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
// Make sure you've required `angular` and `jquery` before
//
//= require documentation_editor/pages
```

 * Add the following dependency in your `application.css`:

 ```css
/*
 * Make sure you've require `bootstrap` before
 *
 *= require documentation_editor/pages
 */
 ```

 * Go to `/doc/admin` to create your first page

## Development

```sh
$ bundle install
$ cd test/dummy
$ rake documentation_editor:install:migrations
$ rake db:migrate
$ rails server
$ open http://localhost:3000/doc/admin
```
