require_relative 'config/router'
require_relative "config/auto_load"

Container.finalize!
run Main
