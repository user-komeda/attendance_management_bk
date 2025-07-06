require 'sinatra/base'
require_relative './root'
require_relative '../helper/Route_helper'

# Sinatraアプリ本体
class Main < Sinatra::Base
  extend RouteHelper

  # ルーティング定義（Rails風）

  Root::ROUTE_CONFIG.each do |route|
    route_resources(route)
  end
end
