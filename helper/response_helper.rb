# frozen_string_literal: true

module ResponseHelper
  def respond_with_data(status_code: 200, id: '', data: [])
    ::Presentation::Response::Factory::ResponseFactory.create_response(status_code: status_code, id: id,
                                                                       response: response, data: data)
  end

  def respond_with_error(error)
    response.status = error.status_code
    response['Content-Type'] = 'application/json'
    { error_code: error.error_code, message: error.message }.to_json
  end
end
