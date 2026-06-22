# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

unless Application::UseCase::BaseUseCase.include?(ContainerHelper)
  Application::UseCase::BaseUseCase.include(ContainerHelper)
end

RSpec.describe 'Router / SinatraSettings / SinatraErrorHandler integration', type: :request do
  include Rack::Test::Methods

  describe 'OPTIONS request (sinatra_settings.rb coverage)' do
    it 'returns 204 for OPTIONS *' do
      options '/users'
      expect(last_response.status).to eq(204)
    end
  end

  describe 'GET /health (router before/after block coverage)' do
    it 'returns 200 status' do
      get '/health'
      expect(last_response.status).to eq(200)
    end

    it 'returns OK body' do
      get '/health'
      expect(last_response.body).to eq('OK')
    end
  end

  describe 'GET /swagger/token (router swagger_user_token / swagger_bff_token coverage)' do
    it 'returns 200 in non-production env' do
      get '/swagger/token'
      expect(last_response.status).to eq(200)
    end

    it 'returns user_token and bff_token in non-production env' do
      get '/swagger/token'
      expect(JSON.parse(last_response.body)).to include('user_token', 'bff_token')
    end
  end

  describe 'StandardError handling (sinatra_error_handler.rb coverage)' do
    before do
      allow(ContextHelper).to receive(:set_context).and_raise(StandardError, 'unexpected error')
    end

    it 'returns 500 when an unexpected StandardError is raised' do
      get '/health'
      expect(last_response.status).to eq(500)
    end
  end
end
