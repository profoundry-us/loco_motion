# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::RecordConverterService do
  let(:debug) { false }
  let(:converter) { described_class.new(debug: debug) }
  
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
          anchor: 'primary'
        },
        {
          title: 'Secondary Button',
          description: 'The secondary button style',
          code: '%button.btn.btn-secondary Secondary',
          anchor: 'secondary'
        }
      ]
    }
  end
  
  describe '#initialize' do
    it 'sets debug mode based on parameter' do
      debug_converter = described_class.new(debug: true)
      non_debug_converter = described_class.new(debug: false)
      
      expect(debug_converter.debug).to be true
      expect(non_debug_converter.debug).to be false
    end
    
    it 'defaults to non-debug mode when not specified' do
      default_converter = described_class.new
      
      expect(default_converter.debug).to be false
    end
  end
  
  describe '#convert' do
    context 'with a valid source file in the examples directory' do
      let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
      
      it 'returns an array of records' do
        records = converter.convert(parsed_data, source_file)
        
        expect(records).to be_an(Array)
        expect(records.length).to eq(3) # 1 component + 2 examples
      end
      
      it 'creates a component record with correct attributes' do
        records = converter.convert(parsed_data, source_file)
        component_record = records.first
        
        expect(component_record[:objectID]).to eq('button')
        expect(component_record[:type]).to eq('component')
        expect(component_record[:component]).to eq('button')
        expect(component_record[:title]).to eq('Button Component')
        expect(component_record[:description]).to eq('Buttons are used to trigger actions or navigate')
        expect(component_record[:url]).to eq('/examples/Daisy::Actions::ButtonComponent')
        expect(component_record[:file_path]).to eq(source_file)
      end
      
      it 'creates example records with correct attributes' do
        records = converter.convert(parsed_data, source_file)
        example_records = records.drop(1) # Skip the component record
        
        expect(example_records.length).to eq(2)
        
        # First example
        expect(example_records[0][:objectID]).to eq('button_primary')
        expect(example_records[0][:type]).to eq('example')
        expect(example_records[0][:component]).to eq('button')
        expect(example_records[0][:title]).to eq('Primary Button')
        expect(example_records[0][:description]).to eq('The primary button style')
        expect(example_records[0][:code]).to eq('%button.btn Primary')
        expect(example_records[0][:url]).to eq('/examples/Daisy::Actions::ButtonComponent#primary')
        
        # Second example
        expect(example_records[1][:objectID]).to eq('button_secondary')
        expect(example_records[1][:url]).to eq('/examples/Daisy::Actions::ButtonComponent#secondary')
      end
    end
    
    context 'when the source file is outside the examples directory' do
      let(:source_file) { 'app/views/some_other_dir/button.html.haml' }
      
      it 'falls back to a default URL format' do
        records = converter.convert(parsed_data, source_file)
        component_record = records.first
        
        expect(component_record[:url]).to eq('/examples/daisy/button')
      end
    end
    
    context 'with data containing only title without examples' do
      let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
      let(:title_only_data) do
        {
          title: 'Button Component',
          description: 'Buttons are used to trigger actions'
          # No examples
        }
      end
      
      it 'returns only the component record' do
        records = converter.convert(title_only_data, source_file)
        
        expect(records.length).to eq(1)
        expect(records.first[:type]).to eq('component')
      end
    end
    
    context 'with data containing only examples without title' do
      let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
      let(:examples_only_data) do
        {
          # No title or description
          examples: [
            {
              title: 'Primary Button',
              description: 'The primary button style',
              code: '%button.btn Primary',
              anchor: 'primary'
            }
          ]
        }
      end
      
      it 'returns only example records' do
        records = converter.convert(examples_only_data, source_file)
        
        expect(records.length).to eq(1)
        expect(records.first[:type]).to eq('example')
      end
    end
    
    context 'with nil data' do
      let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
      
      it 'returns an empty array' do
        records = converter.convert(nil, source_file)
        
        expect(records).to eq([])
      end
    end
    
    context 'with empty data' do
      let(:source_file) { 'app/views/examples/daisy/actions/button.html.haml' }
      let(:empty_data) { {} }
      
      it 'returns an empty array' do
        records = converter.convert(empty_data, source_file)
        
        expect(records).to eq([])
      end
    end
  end
  
  describe '#extract_component_info' do
    context 'with a standard example path' do
      let(:file_path) { 'app/views/examples/daisy/actions/button.html.haml' }
      
      it 'extracts the correct component information' do
        component_info = converter.send(:extract_component_info, file_path)
        
        expect(component_info[:base_name]).to eq('button')
        expect(component_info[:component_url]).to eq('/examples/Daisy::Actions::ButtonComponent')
      end
    end
    
    context 'with a path outside the examples directory' do
      let(:file_path) { 'app/views/some_other_dir/button.html.haml' }
      
      it 'falls back to the default format' do
        component_info = converter.send(:extract_component_info, file_path)
        
        expect(component_info[:base_name]).to eq('button')
        expect(component_info[:component_url]).to eq('/examples/daisy/button')
      end
    end
    
    context 'with a path containing no directories after examples' do
      let(:file_path) { 'app/views/examples/button.html.haml' }
      
      it 'constructs a URL with empty namespace' do
        component_info = converter.send(:extract_component_info, file_path)
        
        expect(component_info[:base_name]).to eq('button')
        expect(component_info[:component_url]).to eq('/examples/::ButtonComponent')
      end
    end
    
    context 'with a compound filename' do
      let(:file_path) { 'app/views/examples/daisy/actions/dropdown_button.html.haml' }
      
      it 'converts the filename to a proper class name' do
        component_info = converter.send(:extract_component_info, file_path)
        
        expect(component_info[:base_name]).to eq('dropdown_button')
        expect(component_info[:component_url]).to eq('/examples/Daisy::Actions::DropdownButtonComponent')
      end
    end
  end
end
