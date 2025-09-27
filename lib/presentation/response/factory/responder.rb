# frozen_string_literal: true

module Presentation
  module Response
    module Factory
      class Responder
        def self.build_responder(response:, payload:)
          raise NotImplementedError
        end
      end
    end
  end
end
