# coding: us-ascii
# frozen_string_literal: true

# Copyright (c) 2012 Kenichi Kamiya

require 'eqq'

class Struct
  module Validatable
    class Error < StandardError; end
    class InvalidValueError < Error; end
    class InvalidWritingError < InvalidValueError; end
    class InvalidAdjustingError < InvalidValueError; end
  end
end

require_relative 'validatable/version'
require_relative 'validatable/class_methods'
require_relative 'validatable/subclass_class_methods'
require_relative 'validatable/subclass_instance_methods'
require_relative 'validatable/core_ext'
