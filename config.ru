# frozen_string_literal: true

require_relative 'config/auto_load'
require_relative 'config/router'
require_relative 'config/boot/rom'
require_relative 'config/boot/persistence'

Container.finalize!
run Main
