# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class Test_Struct_Subclass_Predicate_Adjuster < Test::Unit::TestCase

  Subclass = Struct.new :no_with, :with, :cond_with, :foo do
    validator :no_with
    validator :with do |_|; end
    validator :cond_with, BasicObject do |_|; end
  end.freeze

  INSTANCE = Subclass.new.freeze

  TYPE_PAIRS = {
    class: Subclass
  }.freeze

  [:with_adjuster?].each do |predicate|
    TYPE_PAIRS.each_pair do |type, receiver|
      define_method :"test_#{type}_#{predicate}" do
        assert_same false, receiver.public_send(predicate, :no_with)
        assert_same false, receiver.public_send(predicate, 'no_with')
        assert_same false, receiver.public_send(predicate, 0)
        assert_same false, receiver.public_send(predicate, 0.9)

        assert_same true, receiver.public_send(predicate, :with)
        assert_same true, receiver.public_send(predicate, 'with')
        assert_same true, receiver.public_send(predicate, 1)
        assert_same true, receiver.public_send(predicate, 1.9)

        assert_same true, receiver.public_send(predicate, :cond_with)
        assert_same true, receiver.public_send(predicate, 'cond_with')
        assert_same true, receiver.public_send(predicate, 2)
        assert_same true, receiver.public_send(predicate, 2.9)

        assert_same false, receiver.public_send(predicate, :foo)
        assert_same false, receiver.public_send(predicate, 'foo')
        assert_same false, receiver.public_send(predicate, 3)
        assert_same false, receiver.public_send(predicate, 3.9)
      end
    end
  end

end

class Test_Struct_Subclass_Predicate_Condition < Test::Unit::TestCase

  Subclass = Struct.new :no_with, :with, :with_any, :adj_with, :foo do
    validator :no_with
    validator :with, nil
    validator :with_any, ANYTHING()
    validator :adj_with, nil do |_|; end
  end.freeze

  INSTANCE = Subclass.new.freeze

  TYPE_PAIRS = {
    class: Subclass
  }.freeze

  [:with_condition?, :restrict?].each do |predicate|
    TYPE_PAIRS.each_pair do |type, receiver|
      define_method :"test_#{type}_#{predicate}" do
        assert_same true, receiver.public_send(predicate, :no_with)
        assert_same true, receiver.public_send(predicate, 'no_with')
        assert_same true, receiver.public_send(predicate, 0)
        assert_same true, receiver.public_send(predicate, 0.9)

        assert_same true, receiver.public_send(predicate, :with)
        assert_same true, receiver.public_send(predicate, 'with')
        assert_same true, receiver.public_send(predicate, 1)
        assert_same true, receiver.public_send(predicate, 1.9)

        assert_same true, receiver.public_send(predicate, :with_any)
        assert_same true, receiver.public_send(predicate, 'with_any')
        assert_same true, receiver.public_send(predicate, 2)
        assert_same true, receiver.public_send(predicate, 2.9)

        assert_same true, receiver.public_send(predicate, :adj_with)
        assert_same true, receiver.public_send(predicate, 'adj_with')
        assert_same true, receiver.public_send(predicate, 3)
        assert_same true, receiver.public_send(predicate, 3.9)

        assert_same false, receiver.public_send(predicate, :foo)
        assert_same false, receiver.public_send(predicate, 'foo')
        assert_same false, receiver.public_send(predicate, 4)
        assert_same false, receiver.public_send(predicate, 4.9)

      end
    end
  end

end
