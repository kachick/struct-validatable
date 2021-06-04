# struct-validatable

![Build Status](https://github.com/kachick/struct-validatable/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/struct-validatable.png)](http://badge.fury.io/rb/struct-validatable)

Struct will be able to have validators for each member

## Usage

Require Ruby 2.6 or later

Add below code into your Gemfile

```ruby
gem 'struct-validatable', '>= 0.2.0', '< 0.3.0'
```

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

The pattern builder DSL is just using [eqq](https://github.com/kachick/eqq)

## Links

- [Repository](https://github.com/kachick/struct-validatable)
- [API documents](https://kachick.github.io/struct-validatable/)
