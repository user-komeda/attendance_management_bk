# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::WorkSpace do
  let(:relation) { described_class.allocate }

  describe '#by_ids' do
    it 'filters work_spaces by ids' do
      allow(relation).to receive(:where).with(id: %w[w1 w2])
      relation.by_ids(%w[w1 w2])
      expect(relation).to have_received(:where).with(id: %w[w1 w2])
    end
  end

  describe '#by_slug' do
    it 'filters work_spaces by slug' do
      allow(relation).to receive(:where).with(slug: 'my-workspace')
      relation.by_slug('my-workspace')
      expect(relation).to have_received(:where).with(slug: 'my-workspace')
    end
  end
end
