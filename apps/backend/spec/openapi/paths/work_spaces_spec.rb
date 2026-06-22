# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'WorkSpaces', type: :openapi do
  describe 'GET /work_spaces' do
    it 'returns 200' do
      get '/work_spaces'
      expect(last_response.status).to eq(200)
    end

    it 'has correct optional query parameters' do
      expect(optional_query_parameters('work_spaces.yaml', :get)).to contain_exactly('page', 'per_page', 'search_query')
    end

    it 'touches all schema properties' do
      get '/work_spaces'
      body = json(last_response.body)
      expect(touch_openapi_schema_properties('ListWorkSpacesResponse', body)).to be_a(Set)
      expect_touches_workspace_properties(body['data'])
    end

    def expect_touches_workspace_properties(work_spaces)
      work_spaces.each do |work_space|
        expect(touch_openapi_schema_properties('WorkSpaceWithStatus', work_space)).to be_a(Set)
      end
    end

    it 'touches all schema properties with query parameters' do
      query_params = { page: 1, per_page: 10, search_query: 'test' }
      get '/work_spaces', query_params
      expect_touches_all_schema_properties(json(last_response.body), query_params)
    end

    def expect_touches_all_schema_properties(body, query_params)
      aggregate_failures do
        expect(touch_openapi_schema_properties('ListWorkSpacesResponse', body)).to be_a(Set)
        expect(touch_openapi_schema_properties('PaginationMeta', body['meta'])).to be_a(Set)
        expect(touch_openapi_query_parameters('work_spaces.yaml', :get, query_params)).to be_a(Set)
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

    it 'returns 400 with invalid params' do
      post '/work_spaces', { name: '' }.to_json, json_headers
      expect(last_response.status).to eq(400)
    end
  end
end
