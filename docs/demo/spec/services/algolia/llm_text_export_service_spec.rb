# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::LlmTextExportService do
  let(:service) { described_class.new }
  let(:output_dir) { Rails.root.join('tmp', 'llm_test') }
  let(:index_path) { File.join(output_dir, 'llms.txt') }
  let(:full_path) { File.join(output_dir, 'llms-full.txt') }

  let(:components) do
    [
      {
        component: 'Daisy::Actions::ButtonComponent',
        framework: 'Daisy',
        section: 'Actions',
        base_name: 'ButtonComponent',
        title: 'Buttons',
        description: 'Buttons allow users to take actions.',
        examples_url: 'https://example.com/buttons',
        api_url: 'https://example.com/api',
        file_path: 'https://github.com/example/button.rb',
        names: ['daisy_button'],
        examples: [
          {
            title: 'Basic Button',
            description: 'A simple button.',
            code: <<~HAML
              = doc_example(title: "Basic Button") do |doc|
                - doc.with_description do
                  This is a description.
                = daisy_button "Click me"
            HAML
          }
        ]
      }
    ]
  end

  before do
    FileUtils.mkdir_p(output_dir)
  end

  after do
    FileUtils.rm_rf(output_dir)
  end

  describe '#export_index' do
    it 'generates the llms.txt file' do
      expect(service.export_index(components, index_path)).to be true
      expect(File.exist?(index_path)).to be true

      content = File.read(index_path)
      expect(content).to include('# LocoMotion Documentation Index')
      expect(content).to include('Daisy::Actions::ButtonComponent')
      expect(content).to include('API: https://example.com/api')
      expect(content).to include('Examples: https://example.com/buttons')
    end

    it 'returns false if components are empty' do
      expect(service.export_index([], index_path)).to be false
    end
  end

  describe '#export_full' do
    it 'generates the llms-full.txt file' do
      expect(service.export_full(components, full_path)).to be true
      expect(File.exist?(full_path)).to be true

      content = File.read(full_path)
      expect(content).to include('# LocoMotion Component Library')
      expect(content).to include('=== Component: Daisy::Actions::ButtonComponent')
      expect(content).to include('Group: Actions')
      expect(content).to include('Title: Buttons')
      expect(content).to include('Helpers:')
      expect(content).to include('- daisy_button')
      expect(content).to include('-- Example: Basic Button')
    end

    it 'returns false if components are empty' do
      expect(service.export_full([], full_path)).to be false
    end
  end

  describe '#strip_description_block' do
    it 'removes the description block from the code' do
      code = <<~HAML
        = doc_example(title: "Basic Button") do |doc|
          - doc.with_description do
            This is a description.
          = daisy_button "Click me"
      HAML

      expected_code = <<~HAML.strip
        = doc_example(title: "Basic Button") do |doc|
          = daisy_button "Click me"
      HAML

      expect(service.send(:strip_description_block, code)).to eq(expected_code)
    end

    it 'handles markdown filters in description blocks' do
      code = <<~HAML
        = doc_example(title: "Markdown Example") do |doc|
          - doc.with_description do
            :markdown
              This is markdown.
          = daisy_button "Markdown"
      HAML

      expected_code = <<~HAML.strip
        = doc_example(title: "Markdown Example") do |doc|
          = daisy_button "Markdown"
      HAML

      expect(service.send(:strip_description_block, code)).to eq(expected_code)
    end

    it 'handles class and id selectors in HAML code' do
      code = <<~HAML
        = doc_example(title: "Selectors") do |doc|
          - doc.with_description do
            Description.
          .class-selector
            #id-selector
              = content
      HAML

      expected_code = <<~HAML.strip
        = doc_example(title: "Selectors") do |doc|
          .class-selector
            #id-selector
              = content
      HAML

      expect(service.send(:strip_description_block, code)).to eq(expected_code)
    end

    it 'handles varying indentation in description content' do
      code = <<~HAML
        = doc_example(title: "Indentation") do |doc|
          - doc.with_description do
            This description has
        varying indentation.
          = daisy_button "Indented"
      HAML

      expected_code = <<~HAML.strip
        = doc_example(title: "Indentation") do |doc|
          = daisy_button "Indented"
      HAML

      expect(service.send(:strip_description_block, code)).to eq(expected_code)
    end
  end
end
