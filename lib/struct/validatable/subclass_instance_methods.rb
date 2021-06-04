# coding: us-ascii
# frozen_string_literal: true

class Struct
  module Validatable
    module SubclassInstanceMethods
      alias_method :__class__, :class

      def initialize(*values, **kw_args)
        super
        if kw_args.empty?
          values.each_with_index do |val, idx|
            self[idx] = val
          end
        else
          kw_args.each_pair do |kw, value|
            self[kw] = value
          end
        end
      end

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def []=(key, value)
        autonym = __class__.autonym_for_key(key)

        if __class__.with_adjuster?(autonym)
          begin
            value = instance_exec(value, &__class__.adjuster_for(autonym))
          rescue Exception
            raise Struct::Validatable::InvalidAdjustingError
          end
        end

        if __class__.with_condition?(autonym)
          unless _valid?(__class__.condition_for(autonym), value)
            raise Struct::Validatable::InvalidWritingError,
                  "#{value.inspect} is deficient for #{key}(#{autonym})"
          end
        end

        super
      end

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def valid?(key, value=self[key])
        return true unless __class__.restrict?(key)

        begin
          _valid?(__class__.condition_for(key), value)
        rescue Exception
          false
        end
      end

      private

      # @param [Proc, Method, #===] condition
      def _valid?(condition, value)
        if case condition
           when Proc
             instance_exec(value, &condition)
           when Method
             condition.call(value)
           else
             condition === value
           end
          true
        else
          false
        end
      end
    end
  end
end
