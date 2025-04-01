# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::Index do
  let(:short_name) { 'components' }
  let(:full_index_name) { "loco_motion_#{ENV['ALGOLIA_ENV']}_#{short_name}_#{LocoMotion::VERSION}" }
  let(:client) { instance_double('Algolia::Search::Client') }
  let(:indices_response) { instance_double('Algolia::Search::IndexesResponse') }
  let(:index_items) { [] } # Empty by default, meaning the index doesn't exist

  # Mock records for testing save_objects
  let(:records) do
    [
      {
        objectID: 'component1',
        title: 'Test Component 1',
        description: 'Test description 1',
        group: 'navigation'
      },
      {
        objectID: 'component2',
        title: 'Test Component 2',
        description: 'Test description 2',
        group: 'forms'
      }
    ]
  end

  before do
    # Mock AlgoliaSearch.client to return our test client
    allow(AlgoliaSearch).to receive(:client).and_return(client)

    # Mock ENV['ALGOLIA_ENV'] to return 'test'
    stub_const("ENV", ENV.to_hash.merge('ALGOLIA_ENV' => 'test'))

    # Mock Rails.env to return 'test' (still needed as a fallback)
    allow(Rails).to receive(:env).and_return('test')

    # Mock the list_indices method to return our test response
    allow(client).to receive(:list_indices).and_return(indices_response)
    allow(indices_response).to receive(:items).and_return(index_items)

    # Always stub set_settings by default to avoid unexpected calls
    allow(client).to receive(:set_settings).and_return(nil)
  end

  describe '#initialize' do
    context 'when index does not exist' do
      let(:index_items) { [] }

      it 'configures the index with default settings' do
        expect(client).to receive(:set_settings).with(
          full_index_name,
          instance_of(Algolia::Search::IndexSettings),
          true
        )

        described_class.new(short_name)
      end
    end

    context 'when index already exists' do
      let(:index_items) { [double(name: full_index_name)] }

      it 'does not reconfigure the index' do
        expect(client).not_to receive(:set_settings)

        described_class.new(short_name)
      end
    end

    it 'sets the name correctly' do
      index = described_class.new(short_name)
      expect(index.name).to eq(full_index_name)
    end
  end

  describe '#save_objects' do
    let(:batch_response) { instance_double('Algolia::Search::SaveObjectsResponse') }
    let(:index) { described_class.new(short_name) }

    before do
      # Stub batch to return our test response
      allow(client).to receive(:batch).and_return(batch_response)
    end

    it 'creates batch requests for each record' do
      expect(client).to receive(:batch).with(
        full_index_name,
        instance_of(Algolia::Search::BatchWriteParams)
      ).and_return(batch_response)

      response = index.save_objects(records)
      expect(response).to eq(batch_response)
    end

    it 'creates addObject requests for each record' do
      # Capture the batch params to verify the requests
      expect(client).to receive(:batch) do |index_name, params|
        expect(index_name).to eq(full_index_name)
        expect(params.requests.length).to eq(2)
        expect(params.requests[0].action).to eq('addObject')
        expect(params.requests[0].body).to eq(records[0])
        expect(params.requests[1].action).to eq('addObject')
        expect(params.requests[1].body).to eq(records[1])
        batch_response
      end

      index.save_objects(records)
    end
  end

  describe '#clear_objects' do
    let(:clear_response) { instance_double('Algolia::Search::Response') }
    let(:index) { described_class.new(short_name) }

    before do
      # Stub clear_objects to return our test response
      allow(client).to receive(:clear_objects).and_return(clear_response)
    end

    it 'calls clear_objects on the client' do
      expect(client).to receive(:clear_objects).with(full_index_name).and_return(clear_response)

      response = index.clear_objects
      expect(response).to eq(clear_response)
    end
  end

  describe '#index_name' do
    # We need to test the private method directly
    let(:index_instance) { described_class.new(short_name) }

    it 'formats the name correctly with environment and version' do
      # Create a new instance to avoid interference from the initialized value
      new_index = described_class.new('test_index')
      expect(new_index.name).to eq("loco_motion_#{ENV['ALGOLIA_ENV']}_test_index_#{LocoMotion::VERSION}")
    end
  end

  describe '#default_index_settings' do
    let(:index) { described_class.new(short_name) }

    # Get the private method's result for testing
    let(:settings) do
      # Use send to call the private method
      index.send(:default_index_settings)
    end

    it 'returns a hash with the expected settings' do
      expect(settings).to be_a(Hash)

      # Verify key settings
      expect(settings[:searchable_attributes]).to include('title', 'framework', 'section', 'description')
      expect(settings[:attributes_for_faceting]).to include('filterOnly(framework)', 'filterOnly(section)')
      expect(settings[:custom_ranking]).to include('asc(priority)', 'asc(title)')
      expect(settings[:highlight_pre_tag]).to eq('<em class="highlight">')
      expect(settings[:highlight_post_tag]).to eq('</em>')
    end
  end
end
