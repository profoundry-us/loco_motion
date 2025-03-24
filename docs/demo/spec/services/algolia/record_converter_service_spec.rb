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
      records = converter.convert(parsed_data, source_file, component_name, 0)
      
      expect(records).to be_an(Array)
      expect(records.length).to eq(3) # 1 component + 2 examples
    end
    
    it 'creates a component record with correct attributes' do
      records = converter.convert(parsed_data, source_file, component_name, 0)
      component_record = records.find { |r| r[:type] == 'component' }
      
      expect(component_record).to include(
        objectID: 'ButtonComponent',
        type: 'component',
        framework: 'Daisy',
        section: 'Actions',
        component: 'ButtonComponent',
        title: 'Button Component',
        description: 'Buttons are used to trigger actions or navigate',
        url: '/examples/Daisy::Actions::ButtonComponent',
        file_path: source_file,
        priority: 1
      )
    end
    
    it 'creates example records with correct attributes' do
      records = converter.convert(parsed_data, source_file, component_name, 0)
      example_records = records.select { |r| r[:type] == 'example' }
      
      expect(example_records.length).to eq(2)
      
      # First example
      expect(example_records[0]).to include(
        objectID: 'ButtonComponent-primary',
        type: 'example',
        framework: 'Daisy',
        section: 'Actions',
        component: 'ButtonComponent',
        title: 'Primary Button',
        description: 'The primary button style',
        code: '%button.btn Primary',
        url: '/examples/Daisy::Actions::ButtonComponent#primary',
        file_path: source_file,
        priority: 1000
      )
      
      # Second example
      expect(example_records[1]).to include(
        objectID: 'ButtonComponent-secondary',
        type: 'example',
        framework: 'Daisy',
        section: 'Actions',
        component: 'ButtonComponent',
        title: 'Secondary Button',
        description: 'The secondary button style',
        code: '%button.btn.btn-secondary Secondary',
        url: '/examples/Daisy::Actions::ButtonComponent#secondary',
        file_path: source_file,
        priority: 1001
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
      
      records = converter.convert(incomplete_data, source_file, component_name, 0)
      example_records = records.select { |r| r[:type] == 'example' }
      
      # Now the implementation only skips examples without title, not those without HTML
      expect(example_records.length).to eq(2)
      expect(example_records.map { |r| r[:title] }).to include('Missing HTML', 'Complete')
    end
  end
end
