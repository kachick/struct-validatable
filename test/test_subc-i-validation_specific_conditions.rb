# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class Test_Struct_Validatable_SpecificCondition < Test::Unit::TestCase

  members = [
    :list_only_int, :true_or_false, :has_foo, :has_foo_and_bar,
    :has_ignore, :nand, :all_pass, :rescue_error, :no_exception, :not_integer
  ]

  Sth = Struct.new(*members) do
    validator :list_only_int, SEND(:all?, Integer)
    validator :true_or_false, BOOLEAN()
    validator :has_foo, CAN(:foo)
    validator :has_foo_and_bar, CAN(:foo, :bar)
    validator :has_ignore, AND(1..5, 3..10)
    validator :nand, NAND(1..5, 3..10)
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
  end


  def test_quiet
    sth = Sth.new

    obj = Object.new

    sth.no_exception = obj
    assert_same obj, sth.no_exception
    sth.no_exception = false

    obj.singleton_class.class_eval do
      undef_method :class
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.no_exception = obj
    end
  end

  def test_rescue
    sth = Sth.new

    obj = Object.new

    sth.rescue_error = obj
    assert_same obj, sth.rescue_error
    sth.rescue_error = false

    obj.singleton_class.class_eval do
      def no_name!; end
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.rescue_error = obj
    end
  end

  def test_or
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.all_pass = 11
    end

    sth.all_pass = 1
    assert_equal 1, sth.all_pass
    sth.all_pass = 4
    assert_equal 4, sth.all_pass
    assert_equal true, sth.valid?(:all_pass)
  end

  def test_and
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_ignore = 1
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_ignore= 2
    end

    sth.has_ignore = 3
    assert_equal 3, sth.has_ignore
    assert_equal true, sth.valid?(:has_ignore)

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_ignore = []
    end
  end

  def test_nand
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.nand = 4
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.nand = 4.5
    end

    sth.nand = 2
    assert_equal 2, sth.nand
    assert_equal true, sth.valid?(:nand)
    sth.nand = []
    assert_equal [], sth.nand
  end

  def test_generics
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.list_only_int = [1, '2']
    end

    sth.list_only_int = [1, 2]
    assert_equal [1, 2], sth.list_only_int
    assert_equal true, sth.valid?(:list_only_int)
    sth.list_only_int = []
    assert_equal [], sth.list_only_int
    assert_equal true, sth.valid?(:list_only_int)
    sth.list_only_int << '2'
    assert_equal false, sth.valid?(:list_only_int)
  end

  def test_boolean
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.true_or_false = nil
    end

    assert_equal false, sth.valid?(:true_or_false)

    sth.true_or_false = true
    assert_equal true, sth.true_or_false
    assert_equal true, sth.valid?(:true_or_false)
    sth.true_or_false = false
    assert_equal false, sth.true_or_false
    assert_equal true, sth.valid?(:true_or_false)
  end

  def test_responsible_arg1
    sth = Sth.new
    obj = Object.new

    raise if obj.respond_to? :foo

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_foo = obj
    end

    obj.singleton_class.class_eval do
      def foo; end
    end

    raise unless obj.respond_to? :foo

    sth.has_foo = obj
    assert_equal obj, sth.has_foo
    assert_equal true, sth.valid?(:has_foo)
  end

  def test_responsible_arg2
    sth = Sth.new
    obj = Object.new

    raise if obj.respond_to? :foo
    raise if obj.respond_to? :bar

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end

    obj.singleton_class.class_eval do
      def foo; end
    end

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end

    raise unless obj.respond_to? :foo

    obj.singleton_class.class_eval do
      def bar; end
    end

    raise unless obj.respond_to? :bar

    sth.has_foo_and_bar = obj
    assert_equal obj, sth.has_foo_and_bar
    assert_equal true, sth.valid?(:has_foo_and_bar)
  end

end

class Test_Struct_Subclass_Instance_SpecificConditions_FunctionalCondition < Test::Unit::TestCase

  max = 9

  SthProc = Struct.new :lank do
    validator :lank, -> n {(3..max) === n}
  end

  def test_Proc
    sth = SthProc.new
    sth.lank = 8
    assert_equal 8, sth.lank

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.lank = 2
    end
  end

  SthMethod = Struct.new :lank do
    validator :lank, 7.method(:<)
  end

  def test_Method
    sth = SthMethod.new
    sth.lank = 8
    assert_equal 8, sth.lank

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.lank = 6
    end
  end

end
