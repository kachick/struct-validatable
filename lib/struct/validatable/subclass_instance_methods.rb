class Struct; module Validatable
  
  module SubclassInstanceMethods
    
    alias_method :__class__, :class

    def initialize(*values)
      super
      values.each_with_index do |val, idx|
        self[idx] = val
      end
    end

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def []=(key, value)
      autonym = __class__.autonym_for_key key

      if __class__.with_adjuster? autonym
        begin
          value = instance_exec value, &__class__.adjuster_for(autonym)
        rescue Exception
          raise Validation::InvalidAdjustingError
        end
      end

      if __class__.with_condition?(autonym) 
        unless _valid? __class__.condition_for(autonym), value
          raise Validation::InvalidWritingError,
            "#{value.inspect} is deficient for #{key}(#{autonym})"
        end
      end

      super key, value
    end

    # @param [Symbol, String, #to_sym, Integer, #to_int] key
    def valid?(key, value=self[key])
      return true unless __class__.restrict? key

      begin
        _valid? __class__.condition_for(key), value
      rescue Exception
        false
      end
    end
    
    private
    
    # @param [Proc, Method, #===] condition
    def _valid?(condition, value)
      case condition
      when Proc
        instance_exec value, &condition
      when Method
        condition.call value
      else
        condition === value
      end ? true : false
    end

  end

end; end
