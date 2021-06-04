# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class Test_Struct_Subclass_Instance_Adjuster < Test::Unit::TestCase

  class MyClass
    def self.parse(v)
      raise unless /\A[a-z]+\z/ =~ v
      new
    end
  end

  Sth = Struct.new :chomped, :no_reduced do
    validator :chomped, AND(Symbol, /[^\n]\z/), &WHEN(String, ->v{v.chomp.to_sym})
    validator :no_reduced, Symbol, &->v{v.to_sym}
  end

  def test_WHEN
    sth = Sth.new

    assert_raises Struct::Validatable::InvalidWritingError do
      sth.chomped = :"a\n"
    end

    sth.chomped = "a\n"

    assert_equal :a, sth.chomped

    sth.chomped = :b
    assert_equal :b, sth.chomped
  end

end

class Test_Struct_Subclass_Instance_AdjusterOld < Test::Unit::TestCase

  Sth = Struct.new :age do
    validator :age, Numeric, &->arg{Integer arg}
  end

  def setup
    @sth = Sth.new
    assert_same nil, @sth.age
  end

  def test_procedure
    @sth.age = 10
    assert_same 10, @sth.age
    @sth.age = 10.0
    assert_same 10, @sth.age

    assert_raises Struct::Validatable::InvalidAdjustingError do
      @sth.age = '10.0'
    end

    @sth.age = '10'
    assert_same 10, @sth.age
  end

end
