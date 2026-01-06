# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::AuthUsers do
  let(:relation) { described_class.allocate }

  describe '#by_email' do
    before do
      allow(relation).to receive(:where).and_return(relation)
    end

    it 'filters auth_users by email' do
      relation.by_email('test@example.com')
      expect(relation).to have_received(:where).with(email: 'test@example.com')
    end
  end
end
