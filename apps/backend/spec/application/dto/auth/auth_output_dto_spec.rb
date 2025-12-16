# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::Auth::AuthOutputDto do
  describe '.build' do
    it 'builds dto with id and user_id' do
      dto = described_class.build(id: 'auth-1', user_id: 'user-1')
      expect(dto).to have_attributes(id: 'auth-1', user_id: 'user-1')
    end

    it 'allows nil id' do
      dto = described_class.build(id: nil, user_id: 'user-2')
      expect(dto).to have_attributes(id: nil, user_id: 'user-2')
    end
  end
end
