# frozen_string_literal: true

require 'spec_helper'
require 'active_support/core_ext/string/inflections'
require 'loco_motion/algolia/component_indexer'

RSpec.describe LocoMotion::Algolia::ComponentIndexer do
  # Use test data instead of relying on LocoMotion::COMPONENTS
  let(:test_components) do
    {
      'Daisy::Actions::ButtonComponent' => { 
        names: 'button', 
        group: 'Actions', 
        title: 'Buttons', 
        example: 'buttons' 
      },
      'Daisy::DataDisplay::CardComponent' => { 
        names: 'card', 
        group: 'Data', 
        title: 'Cards', 
        example: 'cards' 
      }
    }
  end
  
  let(:indexer) { described_class.new(test_components) }

  describe '#extract_components' do
    it 'extracts components from the provided components data' do
      # Call the method under test
      result = indexer.extract_components

      # Verify the results
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      
      # Verify the first component
      button = result.find { |c| c[:component_name] == 'Daisy::Actions::ButtonComponent' }
      expect(button).to include(
        objectID: 'Daisy::Actions::ButtonComponent',
        class_name: 'ButtonComponent',
        framework: 'daisy',
        section: 'Actions',
        group: 'Actions',
        title: 'Buttons',
        example: 'buttons',
        helper_names: ['daisy_button']
      )
      
      # Verify the second component
      card = result.find { |c| c[:component_name] == 'Daisy::DataDisplay::CardComponent' }
      expect(card).to include(
        objectID: 'Daisy::DataDisplay::CardComponent',
        class_name: 'CardComponent',
        framework: 'daisy',
        section: 'DataDisplay',
        group: 'Data',
        title: 'Cards',
        example: 'cards',
        helper_names: ['daisy_card']
      )
    end
  end

  describe '#build_component_record' do
    it 'builds a searchable record for a component' do
      # This is a private method, so we need to use send to call it
      result = indexer.send(
        :build_component_record, 
        'Daisy::Feedback::AlertComponent', 
        { 
          names: 'alert', 
          group: 'Feedback', 
          title: 'Alerts', 
          example: 'alerts' 
        }
      )

      # Verify the result
      expect(result).to include(
        objectID: 'Daisy::Feedback::AlertComponent',
        component_name: 'Daisy::Feedback::AlertComponent',
        class_name: 'AlertComponent',
        framework: 'daisy',
        section: 'Feedback',
        group: 'Feedback',
        title: 'Alerts',
        example: 'alerts',
        helper_names: ['daisy_alert']
      )

      # Verify that example_path is included and has the correct format
      expect(result[:example_path]).to eq('/examples/daisy/feedback/alerts')
    end

    it 'handles components with multiple helper names' do
      result = indexer.send(
        :build_component_record, 
        'Daisy::Feedback::LoadingComponent', 
        { 
          names: ['loading', 'loader'], 
          group: 'Feedback', 
          title: 'Loaders', 
          example: 'loaders' 
        }
      )

      # Verify multiple helper names are included
      expect(result[:helper_names]).to eq(['daisy_loading', 'daisy_loader'])
    end
  end

  describe '#calculate_popularity' do
    it 'calculates a popularity score for a component' do
      # Call the private method
      score = indexer.send(
        :calculate_popularity, 
        'Daisy::Actions::ButtonComponent', 
        { names: 'button' }
      )

      # Verify we get a numeric score
      expect(score).to be_a(Numeric)
      expect(score).to be > 0

      # Components with multiple helper methods should have higher scores
      multi_score = indexer.send(
        :calculate_popularity, 
        'Daisy::Feedback::TooltipComponent', 
        { names: ['tooltip', 'tip'] }
      )
      
      single_score = indexer.send(
        :calculate_popularity, 
        'Daisy::Navigation::LinkComponent', 
        { names: 'link' }
      )

      expect(multi_score).to be > single_score
    end
  end
end
