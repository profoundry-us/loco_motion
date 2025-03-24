# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::SearchRecordBuilder do
  let(:root_path) { '/path/to/root' }
  let(:demo_path) { '/path/to/demo' }
  let(:builder) { described_class.new(root_path: root_path, demo_path: demo_path) }
  
  # Mock component data for testing
  let(:component) do
    {
      component_name: 'Daisy::Button',
      framework: 'daisy',
      section: 'actions',
      example: 'button'
    }
  end
  
  # Mock parsed result from HamlParserService
  let(:parser_result) do
    {
      title: 'Button Component',
      description: 'Buttons are used to trigger actions',
      examples: [
        {
          id: 'example1',
          title: 'Basic Button',
          description: 'A simple button example',
          code: '%button.btn Primary'
        },
        {
          id: 'example2',
          title: 'Secondary Button',
          description: 'A secondary button example',
          code: '%button.btn.btn-secondary Secondary'
        }
      ]
    }
  end
  
  # Mock HamlParserService
  let(:parser) { instance_double(Algolia::HamlParserService) }
  
  describe '#enrich_component' do
    context 'when example file exists' do
      before do
        # Mock File.exist? to return true for our test file
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:exist?).with(
          File.join(
            demo_path, 'app', 'views', 'examples', 'daisy', 'actions', 'button.html.haml'
          )
        ).and_return(true)
        
        # Mock HamlParserService
        allow(Algolia::HamlParserService).to receive(:new).and_return(parser)
        allow(parser).to receive(:parse).and_return(parser_result)
      end
      
      it 'adds example_path to the component' do
        enriched_component, _ = builder.enrich_component(component)
        
        expect(enriched_component[:example_path]).to eq('/examples/Daisy::Button')
      end
      
      it 'adds description to the component' do
        enriched_component, _ = builder.enrich_component(component)
        
        expect(enriched_component[:description]).to eq('Buttons are used to trigger actions')
      end
      
      it 'returns examples as the second part of the array' do
        _, examples = builder.enrich_component(component)
        
        expect(examples).to eq(parser_result[:examples])
        expect(examples.length).to eq(2)
        expect(examples.first[:title]).to eq('Basic Button')
      end
    end
    
    context 'when example file does not exist' do
      before do
        # Mock File.exist? to always return false
        allow(File).to receive(:exist?).and_return(false)
      end
      
      it 'adds example_path to the component but returns empty examples' do
        enriched_component, examples = builder.enrich_component(component)
        
        expect(enriched_component[:example_path]).to eq('/examples/Daisy::Button')
        expect(examples).to eq([])
      end
    end
    
    context 'when example_name is not provided' do
      let(:component_without_example) do
        {
          component_name: 'Daisy::Icon',
          framework: 'daisy',
          section: 'display'
          # No example key
        }
      end
      
      it 'adds example_path but returns empty examples' do
        enriched_component, examples = builder.enrich_component(component_without_example)
        
        expect(enriched_component[:example_path]).to eq('/examples/Daisy::Icon')
        expect(examples).to eq([])
      end
    end
    
    context 'when parsing fails' do
      before do
        # Mock File.exist? to return true for our test file
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:exist?).with(
          File.join(
            demo_path, 'app', 'views', 'examples', 'daisy', 'actions', 'button.html.haml'
          )
        ).and_return(true)
        
        # Mock HamlParserService to raise an error
        allow(Algolia::HamlParserService).to receive(:new).and_return(parser)
        allow(parser).to receive(:parse).and_raise('Parsing error')
        
        # Stub Rails.logger to avoid actual output
        allow(Rails.logger).to receive(:debug)
      end
      
      it 'handles errors gracefully and returns empty examples' do
        enriched_component, examples = builder.enrich_component(component)
        
        expect(enriched_component[:example_path]).to eq('/examples/Daisy::Button')
        expect(examples).to eq([])
        expect(enriched_component[:description]).to be_nil
      end
      
      it 'logs errors with Rails.logger' do
        expect(Rails.logger).to receive(:debug).with(/Error extracting examples: Parsing error/).at_least(:once)
        
        builder.enrich_component(component)
      end
    end
  end
  
  describe '#initialize' do
    it 'uses provided root_path and demo_path' do
      custom_builder = described_class.new(
        root_path: '/custom/root',
        demo_path: '/custom/demo'
      )
      
      # We can't directly test instance variables, but we can test behavior
      # by mocking the File.exist? and checking the path used
      allow(File).to receive(:exist?).and_return(false)
      expect(File).to receive(:exist?).with(
        File.join(
          '/custom/demo', 'app', 'views', 'examples', 'daisy', 'actions', 'button.html.haml'
        )
      )
      
      custom_builder.enrich_component(component)
    end
    
    it 'uses root_path as demo_path when demo_path is not provided' do
      root_only_builder = described_class.new(root_path: '/just/root')
      
      # We can't directly test instance variables, but we can test behavior
      # by mocking the File.exist? and checking the path used
      allow(File).to receive(:exist?).and_return(false)
      expect(File).to receive(:exist?).with(
        File.join(
          '/just/root', 'app', 'views', 'examples', 'daisy', 'actions', 'button.html.haml'
        )
      )
      
      root_only_builder.enrich_component(component)
    end
  end
end
