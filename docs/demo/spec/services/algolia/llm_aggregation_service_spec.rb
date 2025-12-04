# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::LlmAggregationService do
  let(:service) { described_class.new }
  let(:component_name) { 'Daisy::Actions::ButtonComponent' }
  let(:mock_components) do
    {
      'Daisy::Actions::ButtonComponent' => {
        example: 'buttons'
      }
    }
  end

  before do
    stub_const('LocoMotion::COMPONENTS', mock_components)

    # Mock file existence check
    allow(File).to receive(:exist?).and_return(true)

    # Mock HamlParserService
    parser_double = instance_double(Algolia::HamlParserService)
    allow(Algolia::HamlParserService).to receive(:new).and_return(parser_double)
    allow(parser_double).to receive(:parse).and_return({
      title: 'Buttons',
      description: 'Button description',
      examples: []
    })

    # Mock LocoMotion::Helpers
    allow(LocoMotion::Helpers).to receive(:component_example_path).with(component_name).and_return('/examples/Daisy::Actions::ButtonComponent')
  end

  describe '#aggregate_component' do
    it 'aggregates component data correctly' do
      result = service.aggregate_component(component_name)

      expect(result).to be_a(Hash)
      expect(result[:component]).to eq(component_name)
      expect(result[:framework]).to eq('Daisy')
      expect(result[:section]).to eq('Actions')
      expect(result[:base_name]).to eq('ButtonComponent')
      expect(result[:title]).to eq('Buttons')
      expect(result[:description]).to eq('Button description')
    end

    it 'constructs the correct URLs' do
      result = service.aggregate_component(component_name)

      expect(result[:examples_url]).to eq('https://loco-motion.profoundry.us/examples/Daisy::Actions::ButtonComponent')
      expect(result[:api_url]).to eq('https://loco-motion.profoundry.us/api-docs')
      expect(result[:file_path]).to eq('https://github.com/profoundry-us/loco_motion/blob/main/app/components/daisy/actions/button_component.rb')
    end

    it 'returns nil if component is not found in registry' do
      result = service.aggregate_component('Unknown::Component')
      expect(result).to be_nil
    end

    it 'returns nil if example file does not exist' do
      allow(File).to receive(:exist?).and_return(false)
      result = service.aggregate_component(component_name)
      expect(result).to be_nil
    end
  end
end
