# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'WorkSpaceId', type: :openapi do
  let(:test_auth_user_id) { '04e8496c-6b8c-4f4f-9746-2d96a10f13ec' }
  let(:conn) { Container.resolve('db.config').gateways[:default].connection }

  def insert_workspace_owner(conn, user_id)
    return if conn[:users].where(id: user_id).first

    conn[:users].insert(
      id: user_id,
      first_name: 'Workspace',
      last_name: 'Owner',
      email: "workspace-owner-#{SecureRandom.uuid}@example.com"
    )
  end

  def insert_workspace_with_membership(conn, workspace_id:)
    user_id = test_auth_user_id
    insert_workspace_owner(conn, user_id)

    conn[:work_spaces].insert(
      id: SecureRandom.uuid,
      name: 'Workspace',
      slug: workspace_id
    )

    conn[:member_ships].insert(
      id: SecureRandom.uuid,
      user_id: user_id,
      work_space_id: conn[:work_spaces].where(slug: workspace_id).get(:id),
      role: 'owner',
      status: 'active'
    )
  end

  describe 'PATCH /work_spaces/:id' do
    let(:workspace_id) { "workspace-#{SecureRandom.hex(4)}" }
    let(:update_properties) do
      {
        name: 'New Workspace',
        slug: "new-workspace-#{SecureRandom.hex(4)}"
      }
    end

    before do
      insert_workspace_with_membership(conn, workspace_id: workspace_id)
    end

    it 'updates workspace with all optional properties' do
      patch "/work_spaces/#{workspace_id}", update_properties.to_json, json_headers
      expect(last_response.status).to eq(204)
    end

    it 'touches update properties for coverage' do
      aggregate_failures do
        expect(update_properties.keys.map(&:to_s)).to match_array(optional_properties('UpdateWorkSpaceRequest'))
        expect(touch_openapi_schema_properties('UpdateWorkSpaceRequest', update_properties)).to be_a(Set)
      end
    end

    it 'returns 400 with invalid params' do
      patch "/work_spaces/#{workspace_id}", { name: '' }.to_json, json_headers
      expect(last_response.status).to eq(400)
    end

    it 'returns 404 for nonexistent workspace' do
      patch '/work_spaces/nonexistent-slug', update_properties.to_json, json_headers
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /work_spaces/:id' do
    let(:workspace_id) { "workspace-#{SecureRandom.hex(4)}" }

    before do
      insert_workspace_with_membership(conn, workspace_id: workspace_id)
    end

    it 'returns 200' do
      get "/work_spaces/#{workspace_id}"
      expect(last_response.status).to eq(200)
      touch_openapi_schema_properties('WorkSpaceWithMemberShips', json(last_response.body))
    end

    it 'returns 404 for nonexistent workspace' do
      get '/work_spaces/nonexistent-slug'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /work_spaces/:id' do
    let(:workspace_id) { "workspace-#{SecureRandom.hex(4)}" }

    before do
      insert_workspace_with_membership(conn, workspace_id: workspace_id)
    end

    it 'returns 204' do
      delete "/work_spaces/#{workspace_id}"
      expect(last_response.status).to eq(204)
    end

    it 'returns 404 for nonexistent workspace' do
      delete '/work_spaces/nonexistent-slug'
      expect(last_response.status).to eq(404)
    end
  end
end
