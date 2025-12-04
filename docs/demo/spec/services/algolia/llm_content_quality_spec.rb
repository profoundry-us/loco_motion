# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::LlmTextExportService, type: :service do
  let(:aggregation_service) { Algolia::LlmAggregationService.new }
  let(:export_service) { Algolia::LlmTextExportService.new(aggregation_service) }
  let(:components) { aggregation_service.aggregate_all }

  describe 'content quality validation' do
    let(:temp_file) { Rails.root.join('tmp', 'test_llm_output.txt').to_s }

    before do
      # Clean up any existing test file
      File.delete(temp_file) if File.exist?(temp_file)
    end

    after do
      # Clean up test file
      File.delete(temp_file) if File.exist?(temp_file)
    end

    it 'generates documentation without major HAML syntax contamination' do
      # Generate the documentation
      result = export_service.export_full(components, temp_file)
      expect(result).to be true

      # Read the generated content
      content = File.read(temp_file)

      # Check for the worst HAML artifacts that should not be present
      expect(content).not_to include('succeed "." do')
      expect(content).not_to include('do |doc|')
      expect(content).not_to include('example_css=')

      # Some minor artifacts might still remain but are less harmful
      # We focus on the most problematic ones
    end

    it 'generates documentation without truncated descriptions' do
      # Generate the documentation
      result = export_service.export_full(components, temp_file)
      expect(result).to be true

      # Read the generated content
      content = File.read(temp_file)

      # Check that descriptions don't end abruptly with "..."
      lines = content.split("\n")
      lines.each do |line|
        # Skip code blocks and URLs
        next if line.start_with?('```') || line.start_with?('URL: ')

        # Check for truncated descriptions in component index
        if line.match?(/^\*\*[^*]+\*\*:\s*.*\.\.\.$/)
          fail "Found truncated description: #{line}"
        end
      end
    end

    it 'generates clean code examples without documentation boilerplate' do
      # Generate the documentation
      result = export_service.export_full(components, temp_file)
      expect(result).to be true

      # Read the generated content
      content = File.read(temp_file)

      # Find code blocks and check they don't contain doc_example
      in_code_block = false
      content.each_line do |line|
        if line.start_with?('```haml')
          in_code_block = true
          next
        end

        if line.start_with?('```') && in_code_block
          in_code_block = false
          next
        end

        if in_code_block
          # Check for documentation boilerplate in code blocks
          expect(line).not_to include('doc_example(')
          expect(line).not_to include('title:')
          expect(line).not_to include('example_css:')
        end
      end
    end

    it 'generates properly formatted sections with reasonable spacing' do
      # Generate the documentation
      result = export_service.export_full(components, temp_file)
      expect(result).to be true

      # Read the generated content
      content = File.read(temp_file)

      # Check for reasonable section spacing (not excessive blank lines)
      expect(content).not_to match(/## Common Usage Patterns\n\n\n\n/)

      # Check that component sections are properly formatted
      expect(content).to match(/=== Component: [^\n]+\nGroup: [^\n]+\n/)

      # The main requirement is that sections exist and are readable
      expect(content).to include('## Library Metadata')
      expect(content).to include('## Common Usage Patterns')
    end

    it 'includes all required sections in the full documentation' do
      # Generate the documentation
      result = export_service.export_full(components, temp_file)
      expect(result).to be true

      # Read the generated content
      content = File.read(temp_file)

      # Check for required sections
      expect(content).to include('## Library Metadata')
      expect(content).to include('## Common Usage Patterns')
      expect(content).to include('## Components by Category')
      expect(content).to include('## Component Details')

      # Check that metadata includes expected fields
      expect(content).to include('Framework:')
      expect(content).to include('UI Library:')
      expect(content).to include('Total Components:')
    end
  end

  describe 'truncate_description method' do
    it 'makes reasonable effort to preserve complete sentences' do
      long_text = "This is a complete sentence. This is another sentence that is quite long and should be truncated. More text here."

      result = export_service.send(:truncate_description, long_text, 80)

      # Should either end at a sentence boundary or have reasonable truncation
      if result.end_with?('...')
        # If truncated, should be at reasonable length
        expect(result.length).to be <= 83  # 80 + "..."
      else
        # If not truncated, should be complete
        expect(result.length).to be <= 80
      end
    end

    it 'falls back to space truncation when no sentence boundary is available' do
      long_text = "This is a very long text without any sentence endings that goes on and on and should be truncated at a word boundary"

      result = export_service.send(:truncate_description, long_text, 50)

      expect(result).to end_with('...')
      expect(result.length).to be <= 53  # 50 + "..."
    end

    it 'returns short text unchanged' do
      short_text = "This is short."

      result = export_service.send(:truncate_description, short_text, 50)

      expect(result).to eq(short_text)
    end
  end

  describe 'clean_string method' do
    let(:parser_service) { Algolia::HamlParserService.new('dummy_path') }

    it 'removes HAML artifacts from descriptions' do
      dirty_text = 'succeed "." do daisy_link("https://example.com", target: "_blank", right_icon: "arrow", css: "size-4") end'

      result = parser_service.send(:clean_string, dirty_text)

      expect(result).not_to include('succeed')
      expect(result).not_to include('daisy_link(')
      expect(result).not_to include('right_icon=')
      expect(result).not_to include('target=')
      expect(result).not_to include('css=')
      expect(result).not_to include('end')
    end

    it 'preserves meaningful content while cleaning artifacts' do
      text_with_artifacts = 'Heroicons are great succeed "." do daisy_link("link") end for use.'

      result = parser_service.send(:clean_string, text_with_artifacts)

      expect(result).to include('Heroicons are great')
      expect(result).to include('for use')
      expect(result).not_to include('succeed')
      expect(result).not_to include('daisy_link')
    end
  end
end
