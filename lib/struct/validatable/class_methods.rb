# coding: us-ascii
# frozen_string_literal: true

class Struct
  module Validatable
    module ClassMethods
      private

      def inherited(subclass)
        super

        subclass.class_eval do
          extend(::Eqq::Buildable)
          extend(SubclassClassMethods)
          include(SubclassInstanceMethods)

          # [Hash] autonym[Symbol] => condition
          @conditions = {}

          # [Hash] autonym[Symbol] => adjuster
          @adjusters = {}
        end
      end
    end
  end
end
