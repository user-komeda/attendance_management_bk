# frozen_string_literal: true
require 'dry/auto_inject'
require_relative './container'

AutoInject = Dry::AutoInject(Container)
