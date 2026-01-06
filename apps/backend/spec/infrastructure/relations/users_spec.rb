# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::Users do
  let(:relation) { described_class.allocate }

  describe '#by_email' do
    before do
      allow(relation).to receive(:where).and_return(relation)
    end

    it 'filters users by email' do
      relation.by_email('test@example.com')
      expect(relation).to have_received(:where)
    end
  end
end
