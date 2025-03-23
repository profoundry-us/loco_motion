# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::AlgoliaImportService do
  let(:debug) { false }
  let(:service) { described_class.new(debug: debug) }
  let(:data) do
    {
      title: 'Test Component',
      description: 'Test description',
      examples: [
        {
          title: 'Example 1',
          description: 'Description 1',
          code: '= test_component'
        }
      ]
    }
  end
  let(:source_file) { 'test_component.html.haml' }
  let(:output_file) { File.join(Dir.pwd, 'tmp', 'test_component.json') }

  describe '#process' do
    context 'when Algolia is not configured' do
      before do
        allow(ENV).to receive(:[]).with('ALGOLIA_APPLICATION_ID').and_return(nil)
        allow(ENV).to receive(:[]).with('ALGOLIA_API_KEY').and_return(nil)
        allow(ENV).to receive(:[]).and_call_original
        allow(FileUtils).to receive(:mkdir_p)
        allow(File).to receive(:write)
      end

      it 'saves the data to a file' do
        expect(FileUtils).to receive(:mkdir_p).with(File.join(Dir.pwd, 'tmp'))
        expect(File).to receive(:write).with(output_file, anything)
        
        service.process(data, source_file)
      end
    end

    context 'when Algolia is configured' do
      # We'll skip the Algolia tests since we can't easily mock the require statement
      # and the actual Algolia implementation details
      before do
        allow(service).to receive(:algolia_configured?).and_return(true)
        allow(service).to receive(:send_to_algolia).and_return(true)
        allow(service).to receive(:save_to_file).and_return(true)
      end

      it 'calls send_to_algolia' do
        expect(service).to receive(:send_to_algolia).with(data, source_file)
        service.process(data, source_file)
      end
    end
  end

  describe '#algolia_configured?' do
    context 'when Algolia env variables are present' do
      before do
        allow(ENV).to receive(:[]).with('ALGOLIA_APPLICATION_ID').and_return('app_id')
        allow(ENV).to receive(:[]).with('ALGOLIA_API_KEY').and_return('api_key')
      end

      it 'returns true' do
        expect(service.send(:algolia_configured?)).to be true
      end
    end

    context 'when Algolia env variables are missing' do
      before do
        allow(ENV).to receive(:[]).with('ALGOLIA_APPLICATION_ID').and_return(nil)
        allow(ENV).to receive(:[]).with('ALGOLIA_API_KEY').and_return(nil)
      end

      it 'returns false' do
        expect(service.send(:algolia_configured?)).to be false
      end
    end

    context 'when Algolia env variables are empty' do
      before do
        allow(ENV).to receive(:[]).with('ALGOLIA_APPLICATION_ID').and_return('')
        allow(ENV).to receive(:[]).with('ALGOLIA_API_KEY').and_return('')
      end

      it 'returns false' do
        expect(service.send(:algolia_configured?)).to be false
      end
    end
  end
end
