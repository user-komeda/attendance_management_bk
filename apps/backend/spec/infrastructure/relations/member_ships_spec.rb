# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Relations::MemberShips do
  subject(:relation) { described_class.allocate }

  describe '#by_user_id' do
    it 'filters by user_id' do
      expect(relation).to receive(:where).with(user_id: 'u1')
      relation.by_user_id('u1')
    end
  end

  describe '#by_work_space_id' do
    it 'filters by work_space_id' do
      expect(relation).to receive(:where).with(work_space_id: 'w1')
      relation.by_work_space_id('w1')
    end
  end

  describe '#plunk_work_space_id_and_status' do
    it 'plucks work_space_id and status' do
      expect(relation).to receive(:pluck).with(:work_space_id, :status)
      relation.plunk_work_space_id_and_status
    end
  end
end
