# frozen_string_literal: true

module Presentation
  module Controller
    class ControllerBase
      include ContainerHelper

      protected

      def create_build_request(request_payload, class_name)
        raise NotImplementedError, "#{self.class} must implement #build_form"
      end

      def invoke_use_case(key, *args)
        raise NotImplementedError, "#{self.class} must implement #invoke_use_case"
      end
    end
  end
end
