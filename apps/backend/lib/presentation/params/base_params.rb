# frozen_string_literal: true
# rbs_inline: enabled

module Presentation
  module Params
    class BaseParams
      class << self
        # @rbs (Hash[Symbol, untyped] params) -> BaseParams
        def build(params)
          raise NotImplementedError
        end
      end
    end
  end
end
