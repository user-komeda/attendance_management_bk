# frozen_string_literal: true

# rbs_inline: enabled

module UtilMethod
  # @rbs (untyped object) -> bool
  def self.nil_or_empty?(object)
    return true if object.nil?
    return object.empty? if object.respond_to?(:empty?)

    false
  end
end
