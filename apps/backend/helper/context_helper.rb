# frozen_string_literal: true

# rbs_inline: enabled

module ContextHelper
  def self.set_context(key, value)
    Thread.current[key] = value
  end

  def self.get_context(key)
    Thread.current[key]
  end
end
