# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :minitest do
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('test/test_helper.rb')  { "test" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "test/controllers/#{m[1]}_test.rb" }
end
