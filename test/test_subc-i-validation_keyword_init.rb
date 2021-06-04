# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class Test_Struct_Validatable_keyword_init < Test::Unit::TestCase
  Sth = Struct.new(:all_pass, :rescue_error, :no_exception, :not_integer, keyword_init: true) do
    validator :all_pass, OR(1..5, 3..10)
    validator :rescue_error, RESCUE(NoMethodError, ->v{v.no_name!})
    validator :no_exception, QUIET(->v{v.class})
    validator :not_integer, NOT(Integer)
  end

  def test_not
    sth = Sth.new

    obj = Object.new

    sth.not_integer = obj
    assert_same obj, sth.not_integer

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.not_integer = 1
    end

    assert_same(obj, Sth.new(not_integer: obj).not_integer)

    assert_raises Struct::Validatable::InvalidWritingError do
      Sth.new(not_integer: 42)
    end
  end


  def test_quiet
    sth = Sth.new

    obj = Object.new

    sth.no_exception = obj
    assert_same obj, sth.no_exception
    sth.no_exception = false

    assert_same(obj, Sth.new(no_exception: obj).no_exception)

    obj.singleton_class.class_eval do
      undef_method :class
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.no_exception = obj
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      Sth.new(no_exception: obj)
    end
  end

  def test_rescue
    sth = Sth.new

    obj = Object.new

    sth.rescue_error = obj
    assert_same obj, sth.rescue_error
    sth.rescue_error = false

    assert_same(obj, Sth.new(rescue_error: obj).rescue_error)

    obj.singleton_class.class_eval do
      def no_name!; end
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.rescue_error = obj
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      Sth.new(rescue_error: obj)
    end
  end

  def test_or
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.all_pass = 11
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      Sth.new(all_pass: 11)
    end

    sth.all_pass = 1
    assert_equal 1, sth.all_pass
    sth.all_pass = 4
    assert_equal 4, sth.all_pass
    assert_equal true, sth.valid?(:all_pass)

    assert_equal(1, Sth.new(all_pass: 1).all_pass)
  end
end
