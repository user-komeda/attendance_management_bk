# frozen_string_literal: true

require_relative 'route_helper/resource_context'
require_relative 'route_helper/support'
require_relative 'route_helper/context_builder'
require_relative 'route_helper/action_definitions'

module RouteHelper
  DEFAULT_ACTIONS = %i[index show create update destroy].freeze

  include RouteHelper::Support
  include RouteHelper::ContextBuilder
  include RouteHelper::ActionDefinitions

  def route_resources(route)
    context, actions = build_resource_context(route: route)
    actions.each { |action| define_route(action, context) }
  end
end
