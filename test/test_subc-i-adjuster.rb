require_relative 'helper'


class Test_Struct_Subclass_Instance_Adjuster < Test::Unit::TestCase

  class MyClass
    def self.parse(v)
      raise unless /\A[a-z]+\z/ =~ v
      new
    end
  end
  
  Sth = Struct.new :chomped, :no_reduced, :reduced, :integer, :myobj do
    validator :chomped, AND(Symbol, /[^\n]\z/), &WHEN(String, ->v{v.chomp.to_sym})
    validator :no_reduced, Symbol, &->v{v.to_sym}
    validator :reduced, Symbol, &INJECT(->v{v.to_s}, ->v{v.to_sym})
    validator :integer, Integer, &PARSE(Integer)
    validator :myobj, ->v{v.instance_of? MyClass}, &PARSE(MyClass)
  end
  
  def test_WHEN
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.chomped = :"a\n"
    end
    
    sth.chomped = "a\n"
    
    assert_equal :a, sth.chomped
    
    sth.chomped = :b
    assert_equal :b, sth.chomped
  end

  def test_INJECT
    sth = Sth.new
    
    assert_raises Validation::UnmanagebleError do
      sth.no_reduced = 1
    end
    
    sth.reduced = 1
    
    assert_equal :'1', sth.reduced
  end
  
  def test_PARSE
    sth = Sth.new
    
    assert_raises Validation::UnmanagebleError do
      sth.integer = '1.0'
    end
    
    sth.integer = '1'
    
    assert_equal 1, sth.integer
    
    assert_raises Validation::UnmanagebleError do
      sth.myobj = '1'
    end
    
    sth.myobj = 'a'
    
    assert_kind_of MyClass, sth.myobj
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

    assert_raises Validation::UnmanagebleError do
      @sth.age = '10.0'
    end
    
    @sth.age = '10'
    assert_same 10, @sth.age
  end

end