# frozen_string_literal: true

module Domain
  module ValueObject
    module User
      class UserName < BaseValueObject
        attr_reader :first_name, :last_name

        private_class_method :new

        def initialize(first_name, last_name)
          super()
          @first_name = first_name
          @last_name = last_name
        end

        def self.build(first_name, last_name)
          validate!(first_name, last_name)
          new(first_name, last_name).freeze
        end

        def full_name
          "#{first_name} #{last_name}"
        end

        class << self
          def self.validate!(first_name, _last_name)
            raise ArgumentError, 'First name cannot be nil' if first_name.nil? || first_name.empty?
            raise ArgumentError, 'Last name cannot be nil' if first_name.nil? || first_name.empty?
          end

          def values
            [first_name, last_name]
          end
        end
      end
    end
  end
end
