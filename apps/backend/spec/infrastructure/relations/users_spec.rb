# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::Users do
  subject(:relation) { described_class.allocate }

  describe '#by_email' do
    it 'filters users by email' do
      expect(relation).to receive(:where).with(any_args)
      relation.by_email('test@example.com')
    end
  end
end
