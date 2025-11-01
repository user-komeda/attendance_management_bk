# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module User
      class UserName < BaseValueObject
        # @rbs @first_name: String
        # @rbs @last_name: String
        attr_reader :first_name, :last_name

        private_class_method :new

        # @rbs (String? first_name, String? last_name) -> void
        def initialize(first_name, last_name)
          super()
          @first_name = first_name
          @last_name = last_name
        end

        # @rbs (String first_name, String last_name) -> UserName
        def self.build(first_name, last_name)
          validate!(first_name, last_name)
          new(first_name, last_name).freeze
        end

        # @rbs () -> String
        def full_name
          "#{first_name} #{last_name}"
        end

        # 繧､繝ｳ繧ｹ繧ｿ繝ｳ繧ｹ繝｡繧ｽ繝・ラ縺ｨ縺励※螳夂ｾｩ
        # @rbs () -> Array[String]
        def values
          [first_name, last_name]
        end

        # @rbs (String first_name, String _last_name) -> void
        def self.validate!(first_name, _last_name)
          raise ArgumentError, 'First name cannot be nil' if first_name.nil? || first_name.empty?
          raise ArgumentError, 'Last name cannot be nil' if first_name.nil? || first_name.empty?
        end
      end
    end
  end
end