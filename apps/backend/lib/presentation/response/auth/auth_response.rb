# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Auth
      class AuthResponse < Presentation::Response::BaseResponse
        # rubocop:disable all
        attr_reader :id, :user_id #:String
        # rubocop:enable all

        # @rbs (id: String, user_id: String) -> void
        def initialize(id:, user_id:)
          super()
          @id = id
          @user_id = user_id
        end

        # @rbs (id: String, user_id: String) -> Hash[Symbol, String]
        def self.build(id:, user_id:)
          new(
            id: id,
            user_id: user_id
          ).to_h
        end

        # @rbs () -> {id: String, user_id: String }
        def to_h
          {
            id: id,
            user_id: user_id
          }
        end
      end
    end
  end
end
