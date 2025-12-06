# frozen_string_literal: true

# rbs_inline: enabled

module UtilMethod
  # @rbs (untyped object) -> bool
  def self.nil_or_empty?(object)
    object.nil? || object.empty?
  end
end
