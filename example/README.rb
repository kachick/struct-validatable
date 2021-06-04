# coding: us-ascii
# frozen_string_literal: true

$VERBOSE = true

require_relative '../lib/struct/validatable'

Person = Struct.new :name do
  validator :name, AND(String, /\w+/)
end

person = Person.new
#person.name = ''         #=> error
person.name = +'Foo Bar'
p person.valid?(:name) #=> true
p person
person.name.clear
p person.valid?(:name) #=> false
p person
