struct-validatable
===================

Description
------------

Struct will have flexible validators for each member.

Usage
------

### Overview

```ruby
require 'struct/validatable'

Person = Struct.new :name do
  validator :name, AND(String, /\w+/)
end

person = Person.new
person.name = ''        #=> error
person.name = 'Foo Bar' #=> pass
person.valid?(:name)    #=> true
person.name.clear
person.valid?(:name)    #=> false
```

### More Examle

* See original library [striuct](https://github.com/kachick/striuct).

Requirements
------------

* Ruby - [1.9.2 or later](http://travis-ci.org/#!/kachick/struct-validatable)
* validation - [0.0.3](https://github.com/kachick/validation)

Install
-------

```bash
$ gem install struct-validatable
```

Build Status
------------

[![Build Status](https://secure.travis-ci.org/kachick/struct-validatable.png)](http://travis-ci.org/kachick/struct-validatable)

Link
----

* [code](https://github.com/kachick/struct-validatable)
* [API](http://kachick.github.com/struct-validatable/yard/frames.html)
* [issues](https://github.com/kachick/struct-validatable/issues)
* [CI](http://travis-ci.org/#!/kachick/struct-validatable)
* [gem](https://rubygems.org/gems/struct-validatable)

License
-------

The MIT X11 License  
Copyright (c) 2011-2012 Kenichi Kamiya  
See the file LICENSE for further details.
