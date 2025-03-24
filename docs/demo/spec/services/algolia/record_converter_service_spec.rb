# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::RecordConverterService do
  let(:converter) { described_class.new }
  
  # Sample parsed HAML data for testing
  let(:parsed_data) do
    {
      title: 'Button Component',
      description: 'Buttons are used to trigger actions or navigate',
      examples: [
        {
          title: 'Primary Button',
          description: 'The primary button style',
          code: '%button.btn Primary',
          html: '<button class="btn">Primary</button>',
          anchor: 'primary'
        },
        {
          title: 'Secondary Button',
          description: 'The secondary button style',
          code: '%button.btn.btn-secondary Secondary',
          html: '<button class="btn btn-secondary">Secondary</button>',
          anchor: 'secondary'
        }
      ]
    }
  end
  
  describe '#initialize' do
    it 'initializes the service' do
      expect(converter).to be_a(described_class)
    end
  end
  
  describe '#convert' do
    before do
      allow(Rails.logger).to receive(:debug)
      # Mock the LocoMotion::Helpers.component_example_path method
      allow(LocoMotion::Helpers).to receive(:component_example_path)
        .with('Daisy::Actions::ButtonComponent')
        .and_return('/examples/Daisy::Actions::ButtonComponent')
    end
    
    let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
    let(:component_name) { 'Daisy::Actions::ButtonComponent' }
    
    it 'returns an array of records' do
      records = converter.convert(parsed_data, source_file, component_name)
      
      expect(records).to be_an(Array)
      expect(records.length).to eq(3) # 1 component + 2 examples
    end
    
    it 'creates a component record with correct attributes' do
      records = converter.convert(parsed_data, source_file, component_name)
      component_record = records.find { |r| r[:type] == 'component' }
      
      expect(component_record).to include(
        objectID: 'button',
        type: 'component',
        component: 'button',
        title: 'Button Component',
        description: 'Buttons are used to trigger actions or navigate',
        url: '/examples/Daisy::Actions::ButtonComponent',
        file_path: source_file
      )
    end
    
    it 'creates example records with correct attributes' do
      records = converter.convert(parsed_data, source_file, component_name)
      example_records = records.select { |r| r[:type] == 'example' }
      
      expect(example_records.length).to eq(2)
      
      # First example
      expect(example_records[0]).to include(
        objectID: 'button_example_1',
        type: 'example',
        component: 'button',
        title: 'Primary Button',
        description: 'The primary button style',
        code: '%button.btn Primary',
        html: '<button class="btn">Primary</button>',
        anchor: 'primary',
        url: '/examples/Daisy::Actions::ButtonComponent#primary',
        file_path: source_file,
        position: 1
      )
      
      # Second example
      expect(example_records[1]).to include(
        objectID: 'button_example_2',
        type: 'example',
        component: 'button',
        title: 'Secondary Button',
        description: 'The secondary button style',
        code: '%button.btn.btn-secondary Secondary',
        html: '<button class="btn btn-secondary">Secondary</button>',
        anchor: 'secondary',
        url: '/examples/Daisy::Actions::ButtonComponent#secondary',
        file_path: source_file,
        position: 2
      )
    end
    
    it 'skips examples without title or HTML' do
      incomplete_data = {
        title: 'Button Component',
        description: 'Buttons are used to trigger actions or navigate',
        examples: [
          { description: 'Missing title', html: '<button>Test</button>', anchor: 'test1' },
          { title: 'Missing HTML', description: 'No HTML content', anchor: 'test2' },
          { title: 'Complete', description: 'This one has everything', html: '<button>OK</button>', anchor: 'test3' }
        ]
      }
      
      records = converter.convert(incomplete_data, source_file, component_name)
      example_records = records.select { |r| r[:type] == 'example' }
      
      expect(example_records.length).to eq(1)
      expect(example_records[0][:title]).to eq('Complete')
    end
  end
  
  describe '#extract_component_info_from_name' do
    before do
      # Mock the LocoMotion::Helpers.component_example_path method
      allow(LocoMotion::Helpers).to receive(:component_example_path)
        .with('Daisy::Actions::ButtonComponent')
        .and_return('/examples/Daisy::Actions::ButtonComponent')
        
      allow(LocoMotion::Helpers).to receive(:component_example_path)
        .with('Daisy::DataDisplay::CardComponent')
        .and_return('/examples/Daisy::DataDisplay::CardComponent')
    end
    
    it 'extracts the correct component information from a simple component name' do
      component_name = 'Daisy::Actions::ButtonComponent'
      result = converter.send(:extract_component_info_from_name, component_name)
      
      expect(result).to eq({
        base_name: 'button',
        component_url: '/examples/Daisy::Actions::ButtonComponent'
      })
    end
    
    it 'extracts the correct component information from a multi-word component name' do
      component_name = 'Daisy::DataDisplay::CardComponent'
      result = converter.send(:extract_component_info_from_name, component_name)
      
      expect(result).to eq({
        base_name: 'card',
        component_url: '/examples/Daisy::DataDisplay::CardComponent'
      })
    end
  end
end
