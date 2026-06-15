# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'WorkSpaces', type: :openapi do
  describe 'GET /work_spaces' do
    it 'returns 200' do
      get '/work_spaces'
      expect(last_response.status).to eq(200)
    end

    it 'has no optional query parameters' do
      expect(optional_query_parameters('work_spaces.yaml', :get)).to be_empty
    end

    it 'touches all schema properties' do
      get '/work_spaces'
      json(last_response.body).each do |work_space|
        expect(touch_openapi_schema_properties('WorkSpaceWithStatus', work_space)).to be_a(Set)
      end
    end
  end

  describe 'POST /work_spaces' do
    let(:request_body) do
      {
        name: 'Development Team',
        slug: "dev-team-#{SecureRandom.uuid}"
      }
    end

    it 'returns 201' do
      post '/work_spaces', request_body.to_json, json_headers
      expect(last_response.status).to eq(201)
    end

    it 'has no optional properties for CreateWorkSpaceRequest' do
      expect(optional_properties('CreateWorkSpaceRequest')).to be_empty
    end

    it 'touches schema properties' do
      aggregate_failures do
        post '/work_spaces', request_body.to_json, json_headers
        expect(touch_openapi_schema_properties('CreateWorkSpaceRequest', request_body)).to be_a(Set)
        expect(touch_openapi_schema_properties('WorkSpaceWithMemberShips', json(last_response.body))).to be_a(Set)
      end
    end
  end
end
