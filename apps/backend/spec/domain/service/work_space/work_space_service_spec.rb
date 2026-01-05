# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Service::WorkSpace::WorkSpaceService do
  subject(:service) { described_class.new }

  let(:work_space_repo) { instance_double(Infrastructure::Repository::WorkSpace::WorkSpaceRepository) }
  let(:slug) { 'test-workspace' }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(service).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(work_space_repo)
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#exists_by_slug?' do
    it 'returns true when workspace exists' do
      allow(work_space_repo).to receive(:find_by_slug).with(slug: slug).and_return(double('WorkSpaceEntity'))
      expect(service.exists_by_slug?(slug: slug)).to be true
    end

    it 'returns false when workspace does not exist' do
      allow(work_space_repo).to receive(:find_by_slug).with(slug: slug).and_return(nil)
      expect(service.exists_by_slug?(slug: slug)).to be false
    end
  end
end
