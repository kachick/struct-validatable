# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class Test_Struct_Subclass_Validation_Util < Test::Unit::TestCase

  ALWAYS_OCCUR_ERROR = ->_{raise Exception}
  peep = nil

  Foo = Struct.new :foo, :bar, :hoge, :some_str do
    validator :foo, nil
    validator :bar, ALWAYS_OCCUR_ERROR
    validator :hoge
    peep = AND(String, /./)
    validator :some_str, peep
  end

  SOME_STR = peep

  def test_predicate_restrict?
    assert_same true, Foo.restrict?(:foo)
    assert_same true, Foo.restrict?(:bar)
    assert_same true, Foo.restrict?(:hoge)
  end

  def test_predicate_with_condition?
    assert_same true, Foo.with_condition?(:foo)
    assert_same true, Foo.with_condition?(:bar)
    assert_same true, Foo.with_condition?(:hoge)
  end

  def test_predicate_instance_valid?
    foo = Foo.new
    assert_same true, foo.valid?(:foo)
    assert_same false, foo.valid?(:bar)
    assert_same true, foo.valid?(:hoge)
    assert_same false, foo.valid?(:some_str)
    foo.some_str = ':)'
    assert_same true, foo.valid?(:some_str)
    foo.some_str.clear
    assert_same false, foo.valid?(:some_str)
  end

  def test_condition_for
    foo = Foo.new
    assert_same nil, foo.class.condition_for(:foo)
    assert_same ALWAYS_OCCUR_ERROR, foo.class.condition_for(:bar)
    assert_same SOME_STR, foo.class.condition_for(:some_str)
  end


end
