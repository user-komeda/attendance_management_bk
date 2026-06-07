# frozen_string_literal: true

# rbs_inline: enabled

module AppEnv
  class Contract < Dry::Validation::Contract
    params do
      required(:DB_URL).filled(:string)
      required(:FRONTEND_ORIGIN).filled(:string)
      required(:JWT_SECRET).filled(:string, min_size?: 32)
      required(:BFF_JWT_SECRET).filled(:string, min_size?: 32)
      required(:JWT_ISSUER).filled(:string)
      required(:JWT_AUDIENCE).filled(:string)
    end
  end

  # @rbs () -> void
  def self.validate!
    result = Contract.new.call(ENV.to_h)

    return if result.success?

    raise result.errors.to_h.to_s
  end

  # @rbs () -> Hash[String, String]
  def self.get
    @get ||= begin
      validate!

      ENV.to_h
    end
  end
end
