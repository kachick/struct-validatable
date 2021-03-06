# coding: us-ascii

require 'validation'

class Struct; module Validatable

  module ClassMethods
    
    private
    
    def inherited(cls)
      super cls
      
      cls.class_eval do
        include ::Validation
        extend ::Struct::Validatable::SubclassClassMethods
        include ::Struct::Validatable::SubclassInstanceMethods

        # [Hash] autonym[Symbol] => condition
        @conditions = {}
        
        # [Hash] autonym[Symbol] => adjuster
        @adjusters = {}
      end
    end
    
  end

end; end
