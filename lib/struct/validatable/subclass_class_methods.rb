# coding: us-ascii
# frozen_string_literal: true

class Struct
  module Validatable
    module SubclassClassMethods
      # @group Utils

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def condition_for(key)
        @conditions.fetch(autonym_for_key(key))
      end

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def with_condition?(key)
        @conditions.key?(autonym_for_key(key))
      end

      alias_method :restrict?, :with_condition?

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def adjuster_for(key)
        @adjusters.fetch(autonym_for_key(key))
      end

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def with_adjuster?(key)
        @adjusters.key?(autonym_for_key(key))
      end

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      def autonym_for_key(key)
        case key
        when ->k { k.respond_to?(:to_sym) }
          autonym_for_member(key)
        when ->k { k.respond_to?(:to_int) }
          members.fetch(key.to_int)
        else
          raise TypeError, key
        end
      end

      # @param [Symbol, String, #to_sym] _name
      def autonym_for_member(_name)
        _name = _name.to_sym

        raise NameError, _name unless members.include?(_name)

        _name
      end

      # @param [Integer, #to_int] index
      def autonym_for_index(index)
        members.fetch(index.to_int)
      end

      def conditionable?(obj)
        case obj
        when Proc
          obj.arity.abs == 1
        when Method
          obj.arity.abs <= 1
        else
          obj.respond_to?(:===)
        end
      end

      # @param [Proc] proc
      def adjustable?(proc)
        (Proc === proc) && (proc.arity.abs == 1)
      end

      # @endgroup

      # Adjuster Builders
      # Apply adjuster when passed pattern.
      # @param pattern [Proc, Method, #===]
      # @param adjuster [Proc, #to_proc]
      # @return [Proc]
      def WHEN(pattern, adjuster)
        unless Eqq.valid?(pattern)
          raise ArgumentError, 'wrong object for pattern'
        end

        unless adjustable?(adjuster)
          raise ArgumentError, 'wrong object for adjuster'
        end

        ->v { _valid?(pattern, v) ? adjuster.call(v) : v }
      end

      private

      # @group Macro for library users

      # @param [Symbol, String, #to_sym, Integer, #to_int] key
      # @param [Proc, Method, #===] condition
      # @return [nil]
      # @yield [value]
      # @yieldreturn [nil]
      def validator(key, condition=BasicObject, &adjuster)
        autonym = autonym_for_key(key)
        raise NameError unless members.include?(autonym)

        if conditionable?(condition)
          @conditions[autonym] = condition
        else
          raise TypeError, 'invalid condition thrown'
        end

        if adjuster
          if adjustable?(adjuster)
            @adjusters[autonym] = adjuster
          else
            raise TypeError, 'invalid adjuster thrown'
          end
        end

        setter = :"#{autonym}="
        alias_method(:"_original_setter_#{setter}", setter)

        undef_method(setter)
        define_method(setter) do |value|
          self[autonym] = value
        end

        nil
      end

      # @endgroup
    end
  end; end
