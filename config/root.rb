# frozen_string_literal: true

require_relative '../lib/presentation/controller/root_controller'

class Root
  ROUTE_CONFIG = [
    { base_path: "/", controller:Controller::RootController, only: [:index,:show] },
    # { base_path: "/users", controller: RootController, only: [:index, :show] }
  ]
end