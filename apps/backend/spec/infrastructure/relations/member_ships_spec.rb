# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::MemberShips do
  let(:relation) { described_class.allocate }

  describe '#by_user_id' do
    it 'filters by user_id' do
      allow(relation).to receive(:where).with(user_id: 'u1')
      relation.by_user_id('u1')
      expect(relation).to have_received(:where).with(user_id: 'u1')
    end
  end

  describe '#by_work_space_id' do
    it 'filters by work_space_id' do
      allow(relation).to receive(:where).with(work_space_id: 'w1')
      relation.by_work_space_id('w1')
      expect(relation).to have_received(:where).with(work_space_id: 'w1')
    end
  end

  describe '#plunk_work_space_id_and_status' do
    it 'plucks work_space_id and status' do
      allow(relation).to receive(:pluck).with(:work_space_id, :status)
      relation.plunk_work_space_id_and_status
      expect(relation).to have_received(:pluck).with(:work_space_id, :status)
    end
  end
end
