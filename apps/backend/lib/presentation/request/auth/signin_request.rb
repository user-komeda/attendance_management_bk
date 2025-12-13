# frozen_string_literal: true

# rbs_inline: enabled

#
# module Presentation
#   module Request
#     module Auth
#       class SigninRequest < AuthBaseRequest
#         # @rbs @id: String?
#         # @rbs @first_name: String
#         # @rbs @last_name: String
#         # @rbs @email: String
#         attr_reader :email, :password
#
#         # @rbs ({ first_name: String, last_name: String, email: String }) -> void
#         def initialize(params)
#           super()
#           @email = params[:email]
#           @password = params[:password]
#         end
#
#         # @rbs () -> ::Application::Dto::User::CreateUserInputDto
#         def convert_to_dto
#           CREATE_INPUT_DTO.new(
#             first_name: @first_name,
#             last_name: @last_name,
#             email: @email
#           )
#         end
#
#         # @rbs ({ first_name: String, last_name: String, email: String }) -> CreateUserRequest
#         def self.build(params)
#           validate(params)
#           CreateUserRequest.new(params)
#         end
#
#         class << self
#           private
#
#           # @rbs ({ first_name: String, last_name: String, email: String }) -> void
#           def validate(params)
#             result = UserBaseRequest::CREATE_CONTRACT.new.call(params)
#             return unless result.failure?
#
#             raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
#           end
#         end
#       end
#     end
#   end
# end
