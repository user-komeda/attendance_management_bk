# frozen_string_literal: true

# rbs_inline: enabled

module ContainerHelper
  # @rbs (String key) -> untyped
  def resolve(key)
    Container.resolve(key)
  end
end
