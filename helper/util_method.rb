# frozen_string_literal: true

module UtilMethod
  def self.nil_or_empty(object)
    object.nil? || object.empty?
  end
end
