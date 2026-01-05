# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::AuthUsers do
  subject(:relation) { described_class.allocate }

  describe '#by_email' do
    it 'filters auth_users by email' do
      expect(relation).to receive(:where).with(email: 'test@example.com')
      relation.by_email('test@example.com')
    end
  end
end
