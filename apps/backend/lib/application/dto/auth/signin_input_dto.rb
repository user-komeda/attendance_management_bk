# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module Auth
      class SigninInputDto < InputBaseDto
        attr_reader :email, :password

        def initialize(params)
          super()
          @email = params[:email]
          @password = params[:password]
        end

        # def convert_to_entity
        #
        # end
      end
    end
  end
end
