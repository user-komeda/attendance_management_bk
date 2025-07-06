# frozen_string_literal: true

module RouteHelper
  def route_resources(route)
    base_path = route[:base_path]
    controller = route[:controller]
    only = route[:only]
    puts(only)
    only.each do |action|
      case action
      when :index
        get base_path do
          controller.new.index
        end
      when :show
        puts("show")
        get "#{base_path}:id" do
          controller.new.show
        end
      when :new
        get "#{base_path}new" do
          controller.new.new
        end
      when :create
        post base_path do
          controller.new.create(params)
        end
      end
    end
  end
end