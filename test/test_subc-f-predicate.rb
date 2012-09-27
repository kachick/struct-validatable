require_relative 'helper'
require 'struct/alias_member'

class Test_Struct_Subclass_Predicate_Adjuster < Test::Unit::TestCase

  class Subclass < Struct.new :no_with, :with, :cond_with, :foo
    validator :no_with
    alias_member :als_no_with, :no_with
    validator :with do |_|; end
    alias_member :als_with, :with
    validator :cond_with, BasicObject do |_|; end
    alias_member :als_cond_with, :cond_with
  end.freeze

  INSTANCE = Subclass.new.freeze
  
  TYPE_PAIRS = {
    class: Subclass,
  }.freeze

  [:with_adjuster?].each do |predicate|
    TYPE_PAIRS.each_pair do |type, reciever|
      define_method :"test_#{type}_#{predicate}" do
        assert_same false, reciever.public_send(predicate, :no_with)
        assert_same false, reciever.public_send(predicate, :als_no_with)
        assert_same false, reciever.public_send(predicate, 'no_with')
        assert_same false, reciever.public_send(predicate, 'als_no_with')
        assert_same false, reciever.public_send(predicate, 0)
        assert_same false, reciever.public_send(predicate, 0.9)
        
        assert_same true, reciever.public_send(predicate, :with)
        assert_same true, reciever.public_send(predicate, :als_with)
        assert_same true, reciever.public_send(predicate, 'with')
        assert_same true, reciever.public_send(predicate, 'als_with')
        assert_same true, reciever.public_send(predicate, 1)
        assert_same true, reciever.public_send(predicate, 1.9)
        
        assert_same true, reciever.public_send(predicate, :cond_with)
        assert_same true, reciever.public_send(predicate, :als_cond_with)
        assert_same true, reciever.public_send(predicate, 'cond_with')
        assert_same true, reciever.public_send(predicate, 'als_cond_with')
        assert_same true, reciever.public_send(predicate, 2)
        assert_same true, reciever.public_send(predicate, 2.9)
        
        assert_same false, reciever.public_send(predicate, :foo)
        assert_same false, reciever.public_send(predicate, 'foo')
        assert_same false, reciever.public_send(predicate, 3)
        assert_same false, reciever.public_send(predicate, 3.9)
      end
    end
  end

end

class Test_Struct_Subclass_Predicate_Condition < Test::Unit::TestCase

  class Subclass < Struct.new :no_with, :with, :with_any, :adj_with, :foo
    validator :no_with
    alias_member :als_no_with, :no_with
    validator :with, nil
    alias_member :als_with, :with
    validator :with_any, ANYTHING?
    alias_member :als_with_any, :with_any
    validator :adj_with, nil do |_|; end
    alias_member :als_adj_with, :adj_with
    alias_member :als_foo, :foo
  end.freeze

  INSTANCE = Subclass.new.freeze
  
  TYPE_PAIRS = {
    class: Subclass,
  }.freeze

  [:with_condition?, :restrict?].each do |predicate|
    TYPE_PAIRS.each_pair do |type, reciever|
      define_method :"test_#{type}_#{predicate}" do
        assert_same true, reciever.public_send(predicate, :no_with)
        assert_same true, reciever.public_send(predicate, :als_no_with)
        assert_same true, reciever.public_send(predicate, 'no_with')
        assert_same true, reciever.public_send(predicate, 'als_no_with')
        assert_same true, reciever.public_send(predicate, 0)
        assert_same true, reciever.public_send(predicate, 0.9)
        
        assert_same true, reciever.public_send(predicate, :with)
        assert_same true, reciever.public_send(predicate, :als_with)
        assert_same true, reciever.public_send(predicate, 'with')
        assert_same true, reciever.public_send(predicate, 'als_with')
        assert_same true, reciever.public_send(predicate, 1)
        assert_same true, reciever.public_send(predicate, 1.9)

        assert_same true, reciever.public_send(predicate, :with_any)
        assert_same true, reciever.public_send(predicate, :als_with_any)
        assert_same true, reciever.public_send(predicate, 'with_any')
        assert_same true, reciever.public_send(predicate, 'als_with_any')
        assert_same true, reciever.public_send(predicate, 2)
        assert_same true, reciever.public_send(predicate, 2.9)
  
        assert_same true, reciever.public_send(predicate, :adj_with)
        assert_same true, reciever.public_send(predicate, :als_adj_with)
        assert_same true, reciever.public_send(predicate, 'adj_with')
        assert_same true, reciever.public_send(predicate, 'als_adj_with')
        assert_same true, reciever.public_send(predicate, 3)
        assert_same true, reciever.public_send(predicate, 3.9)
        
        assert_same false, reciever.public_send(predicate, :foo)
        assert_same false, reciever.public_send(predicate, :als_foo)
        assert_same false, reciever.public_send(predicate, 'foo')
        assert_same false, reciever.public_send(predicate, 'als_foo')
        assert_same false, reciever.public_send(predicate, 4)
        assert_same false, reciever.public_send(predicate, 4.9)

      end
    end
  end

end
