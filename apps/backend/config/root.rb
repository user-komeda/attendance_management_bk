# frozen_string_literal: true

UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
SLUG_FORMAT = /\A(?!-)(?!.*--)[a-z0-9-]{9,32}(?<!-)\z/i
CONTENT_API_FORMAT = /\A[a-z0-9-]{3,32}\z/i

class Root
  CUSTOM_ROUTE_CONFIG = [
    { http_method: 'post', path: '/signup', controller: Presentation::Controller::Auth::AuthController,
      action: :signup, code: 201 },
    { http_method: 'post', path: '/signin', controller: Presentation::Controller::Auth::AuthController,
      action: :signin }
  ].freeze
  ROUTE_CONFIG = [
    { resource_name: 'users', controller: Presentation::Controller::User::UserController, only: %i[index show update],
      id_format: UUID_FORMAT },
    { resource_name: 'work_spaces', controller: Presentation::Controller::WorkSpace::WorkSpaceController,
      id_format: SLUG_FORMAT },
    { resource_name: 'content_api', controller: Presentation::Controller::ContentApi::ContentApiController,
      id_format: UUID_FORMAT, only: %i[show create update destroy],
      parent_resource: { name: 'work_spaces', id_format: SLUG_FORMAT } }
  ].freeze
end
