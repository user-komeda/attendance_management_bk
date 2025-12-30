# frozen_string_literal: true

class Root
  CUSTOM_ROUTE_CONFIG = [
    { http_method: 'post', path: '/signup', controller: Presentation::Controller::Auth::AuthController,
      action: :signup, code: 201 },
    { http_method: 'post', path: '/signin', controller: Presentation::Controller::Auth::AuthController,
      action: :signin }
  ].freeze
  ROUTE_CONFIG = [
    { base_path: '/', controller: Presentation::Controller::User::UserController, only: %i[index show update] }
  ].freeze
end
