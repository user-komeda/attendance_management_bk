# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::ContentApi::ContentApiResponse do
  def expected_hash(id:, work_space_id:)
    {
      id: id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    }
  end

  let(:id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:content_api_data) do
    double(
      id: id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    )
  end
  let(:built_array) { described_class.build_from_array(content_api_list: [content_api_data, content_api_data]) }

  describe '.build' do
    subject(:result) { described_class.build(content_api: content_api_data) }

    it { expect(result).to include(id: id, work_space_id: work_space_id) }
    it { expect(result).to include(name: 'Articles', endpoint: 'articles', api_type: 'list') }
  end

  describe '.build_from_array' do
    it { expect(built_array).to be_an(Array) }
    it { expect(built_array.length).to eq(2) }
    it { expect(built_array.first).to include(id: id, name: 'Articles') }
    it { expect(described_class.build_from_array(content_api_list: [])).to eq([]) }
  end

  describe '#to_h' do
    let(:response) do
      described_class.new(
        id: id,
        work_space_id: work_space_id,
        name: 'Articles',
        endpoint: 'articles',
        api_type: 'list'
      )
    end

    it { expect(response.to_h).to eq(expected_hash(id: id, work_space_id: work_space_id)) }
  end
end
