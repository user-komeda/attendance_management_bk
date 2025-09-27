# frozen_string_literal: true

class Root
  ROUTE_CONFIG = [
    { base_path: '/', controller: Presentation::Controller::User::UserController }
  ].freeze
end
