# coding: us-ascii

class Struct; module Validatable

  module SubclassClassMethods
  
    # @group Utils

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def condition_for(key)
      @conditions.fetch autonym_for_key(key)
    end

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def with_condition?(key)
      @conditions.has_key? autonym_for_key(key)
    end

    alias_method :restrict?, :with_condition?

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def adjuster_for(key)
      @adjusters.fetch autonym_for_key(key)
    end

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def with_adjuster?(key)
      @adjusters.has_key? autonym_for_key(key)
    end

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def autonym_for_key(key)
      case key
      when ->k{k.respond_to? :to_sym}
        autonym_for_member key
      when ->k{k.respond_to? :to_int}
        members.fetch key.to_int
      else
        raise TypeError, key
      end
    end

    # @param [Symbol, String, #to_sym] _name
    def autonym_for_member(_name)
      _name = _name.to_sym

      if respond_to? :alias_member
        if @aliases.has_key? _name
          return @aliases.fetch(_name)
        end
      end

      raise NameError, _name unless members.include? _name

      _name
    end

    # @param [Integer, #to_int] index
    def autonym_for_index(index)
      members.fetch index.to_int
    end

    def conditionable?(obj)
      case obj
      when Proc
        obj.arity.abs == 1
      when Method
        obj.arity.abs <= 1
      else
        obj.respond_to? :===
      end
    end

    # @param [Proc] _proc
    def adjustable?(_proc)
      _proc.respond_to?(:call) && (_proc.arity.abs == 1)
    end

    # @endgroup

    private

    # @group Macro for library users
    
    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    # @param [Proc, Method, #===] condition
    # @return [nil]
    # @yield [value]
    # @yieldreturn [nil]
    def validator(key, condition=BasicObject, &adjuster)
      autonym = autonym_for_key key
      raise NameError unless members.include? autonym

      if conditionable? condition
        @conditions[autonym] = condition
      else
        raise TypeError, 'invalid condition thrown'
      end

      if block_given?
        if adjustable? adjuster
          @adjusters[autonym] = adjuster
        else
          raise TypeError, 'invalid adjuster thrown'
        end
      end

      setter = :"#{autonym}="
      alias_method :"_original_setter_#{setter}", setter
      
      undef_method setter
      define_method setter do |value|
        self[autonym] = value
      end

      nil
    end
    
    # @endgroup

  end

end; end
