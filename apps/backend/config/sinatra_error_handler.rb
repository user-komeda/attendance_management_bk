# frozen_string_literal: true

module SinatraErrorHandler
  include ResponseHelper

  def self.registered(app)
    app.error do
      e = env['sinatra.error']
      respond_with_error(e)
    end
  end
end
