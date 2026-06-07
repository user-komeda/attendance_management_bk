# frozen_string_literal: true

# rbs_inline: enabled

module FieldErrors
  # @rbs (untyped errors) -> Array[{ key: String, message: String }]
  def self.build_field_errors(errors)
    errors.to_h.flat_map do |key, messages|
      Array(messages).map do |message|
        {
          key: key.to_s,
          message: message.to_s
        }
      end
    end
  end
end
