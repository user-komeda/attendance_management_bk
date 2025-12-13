# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module Auth
      class AuthOutputDto < BaseDto
        attr_reader :id, :user_id # : String

        private_class_method :new

        # @rbs (id: String?, user_id: String) -> void
        def initialize(id:, user_id:)
          super()
          @id = id
          @user_id = user_id
        end

        # @rbs (id: String?, user_id: String) -> AuthOutputDto
        def self.build(id:, user_id:)
          new(
            id: id,
            user_id: user_id
          )
        end
      end
    end
  end
end
