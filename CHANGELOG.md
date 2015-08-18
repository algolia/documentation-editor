Changelog
==========

For transparency and insight into our release cycle, releases will be numbered 
with the follow format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backwards compatibility bumps the major
* New additions without breaking backwards compatibility bumps the minor
* Bug fixes and misc changes bump the patch

For more information on semantic versioning, please visit http://semver.org/.

---

### 0.2.1 Aug 18, 2015

* Only override the title & slug if set

### 0.2.0 Aug 18, 2015

* Add page titles support

### 0.1.2 Aug 4, 2015

* Fixed the `is_admin` before_filter

### 0.1.1 Aug 3, 2015

* Throw an ActiveRecord::RecordNotFound exception if a slug is not found

### 0.1.0 Aug 3, 2015

* Ability to setup a custom before_filter on the show & preview actions

### 0.0.7 Aug 3, 2015

* Use a global conditions stack to handle wrongly nested children

### 0.0.6 Aug 3, 2015

* Ensure the cache fragments depends on the query parameters as well

### 0.0.5 Aug 3, 2015

* Fixed page publication

### 0.0.4 Aug 3, 2015

* Fixed publication boolean

### 0.0.3 Aug 2, 2015

* Do not include the test files in the gem

### 0.0.2 Aug 2, 2015

* Redirects documentation-editor to documentation_editor to ease the gem requirements.

### 0.0.1 Aug 2, 2015

* Initial release
