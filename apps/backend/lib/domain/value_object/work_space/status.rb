# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module WorkSpace
      class Status < BaseValueObject
        # rubocop:disable all
        attr_reader :value #: String
        # rubocop:enable all

        private_class_method :new

        # @rbs (String? value) -> void
        def initialize(value)
          super()
          @value = value
        end

        # @rbs (String status) -> Status
        def self.build(status)
          validate!(status)
          new(status).freeze
        end

        # @rbs () -> Array[String]
        def values
          [value]
        end

        # @rbs (String args) -> void
        def self.validate!(args)
          permitted_statuses = %w[active pending suspend]
          raise ArgumentError, "Values not permitted in status: #{args}" unless permitted_statuses.include?(args)
        end
      end
    end
  end
end
