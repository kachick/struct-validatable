* ***This repository is archived***
* ***No longer maintained***
* ***All versions have been yanked from https://rubygems.org for releasing valuable namespace for others***

# struct-validatable

![Build Status](https://github.com/kachick/struct-validatable/actions/workflows/test_behaviors.yml/badge.svg?branch=main)

Struct will be able to have validators for each member

## Usage

Require Ruby 2.7 or later

Add below code into your Gemfile

```ruby
gem 'struct-validatable', '~> 0.3.0'
```

### Overview

```ruby
require 'struct/validatable'

Person = Struct.new :name do
  validator :name, AND(String, /\w+/)
end

person = Person.new
person.name = ''        #=> error
person.name = +'Foo Bar' #=> pass
person.valid?(:name)    #=> true
person.name.clear
person.valid?(:name)    #=> false
```

* The pattern builder DSL is just using [eqq](https://github.com/kachick/eqq)
* Supporting `keyword_init: true`

## Links

* [Repository](https://github.com/kachick/struct-validatable)
* [API documents](https://kachick.github.io/struct-validatable/)

## License

MIT License - 2011 - Kenichi Kamiya
