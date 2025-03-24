# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::HamlParserService do
  let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'example.html.haml') }
  let(:parser) { described_class.new(file_path) }
  
  # Create test fixture directory and files
  before(:all) do
    fixture_dir = File.join(Rails.root, 'spec', 'fixtures', 'haml_parser')
    FileUtils.mkdir_p(fixture_dir)
    
    # Create a test HAML file with documentation and examples
    File.write(File.join(fixture_dir, 'example.html.haml'), <<~'HAML')
      = doc_title title: "Checkboxes"
        %p
          Here are some examples showcasing checkbox components.
        %p
          :markdown
            These components support the following features:
            * Custom labels
            * Disabled state
            * Form integration
      
      = doc_example title: "Basic Checkbox"
        - doc.with_description do
          %p This is a basic checkbox example with a label.
          %p
            :markdown
              The checkbox requires the following attributes:
              * `id` - Unique identifier
              * `label` - Text label for the checkbox
        .example
          = render Daisy::DataInput::Checkbox.new(label: "Accept terms", id: "example-checkbox-1")
      
      = doc_example title: "Disabled Checkbox"
        - doc.with_description do
          %p A checkbox can be disabled to prevent user interaction.
          %p.note When disabled, the checkbox cannot be checked or unchecked.
        .example
          = render Daisy::DataInput::Checkbox.new(label: "Disabled option", id: "example-checkbox-2", disabled: true)
    HAML
    
    # Create a HAML file with complex nested content
    File.write(File.join(fixture_dir, 'complex.html.haml'), <<~'HAML')
      = doc_title title: "Complex Component"
        %p This is a complex component with nested elements and complex attributes.
        %p
          :markdown
            ## Features
            * Responsive design
            * Interactive elements
            * **Customizable** appearance

      = doc_example title: "Nested Content Example"
        - doc.with_description do
          %p This example demonstrates deeply nested content with multiple attributes.
          %div.info-box
            %p
              :markdown
                The component supports these interactions:
                1. Click to toggle
                2. Button for closing
                3. Save/cancel actions
          %p.note Make sure to include all required attributes.
        .example
          .card.shadow-lg{id: "complex-card", data: {controller: "card", action: "click->card#toggle"}}
            .card-header.flex.items-center.justify-between
              %h3.text-xl Card Title
              %button.btn.btn-sm{data: {action: "click->card#close"}}
                %i.fas.fa-times
            .card-body
              %p This is a paragraph with some text.
              %ul.list
                - 3.times do |i|
                  %li.list-item= "Item #{i + 1}"
              = render Daisy::DataInput::Checkbox.new(label: "I agree", id: "complex-checkbox")
            .card-footer
              %button.btn.btn-primary{data: {action: "click->card#save"}} Save
              %button.btn.btn-secondary Cancel
    HAML

    # Create a HAML file with multiple examples but no descriptions
    File.write(File.join(fixture_dir, 'no_descriptions.html.haml'), <<~'HAML')
      = doc_title title: "No Descriptions"
        %p Examples without description blocks.
        %p
          :markdown
            This component has examples **without** explicit descriptions.

      = doc_example title: "No Description Example"
        .example
          = render Daisy::DataInput::Checkbox.new(label: "No description", id: "no-desc-checkbox")

      = doc_example title: "Another No Description"
        .example
          = render Daisy::DataInput::Checkbox.new(label: "Still no description", id: "no-desc-checkbox-2")
    HAML

    # Create a HAML file with special characters and UTF-8 content
    File.write(File.join(fixture_dir, 'special_chars.html.haml'), <<~'HAML')
      = doc_title title: "Special Characters & UTF-8 Test"
        %p
          Testing with special characters: éèêë, ñ, üû, and symbols like .
        %p
          :markdown
            ## Internationalization
            Support for *international* characters is **essential** for global applications.

      = doc_example title: "UTF-8 Example"
        - doc.with_description do
          %p Description with emoji  and other special chars "'<>&.
          %p
            :markdown
              Examples of emoji:
              * Thumbs up
              * Celebration
              * Fire
        .example
          = render Daisy::Button.new(text: "Click me! ", id: "utf8-button")
    HAML

    # Create a HAML file with documentation mixed with regular content
    File.write(File.join(fixture_dir, 'mixed_content.html.haml'), <<~'HAML')
      = doc_title title: "Mixed Content Example"
        %p This page mixes regular content with documentation blocks.
        %p
          :markdown
            ## Purpose
            To demonstrate how the parser handles:
            * Regular page content
            * Documentation blocks
            * Mixed formats

      = doc_example title: "Example After Regular Content"
        - doc.with_description do
          %p This example appears after some non-documentation content.
          %div.note
            %p
              :markdown
                The parser should still be able to extract:
                1. The document title
                2. Example titles and descriptions
                3. Example code blocks
        .example
          = render Daisy::Badge.new(text: "New", variant: "primary")

      %header.page-header
        %h1 Documentation Page
        %p This is a header section

      .regular-content
        %p This is just regular content, not part of documentation.

      %footer
        %p Regular page footer
    HAML

    # Create a HAML file with only comments
    File.write(File.join(fixture_dir, 'comments_only.html.haml'), <<~'HAML')
      -# This is a HAML comment
      -# Another comment line
      -# No actual documentation or examples here
      
      / Another type of comment
    HAML

    # Create an empty HAML file
    File.write(File.join(fixture_dir, 'empty.html.haml'), "")
  end
  
  # Clean up test fixtures
  after(:all) do
    FileUtils.rm_rf(File.join(Rails.root, 'spec', 'fixtures', 'haml_parser'))
  end
  
  describe '#initialize' do
    it 'sets the file path' do
      custom_parser = described_class.new('/custom/path')
      
      # We can't directly test instance variables, but we can test behavior
      expect(custom_parser.instance_variable_get('@file_path')).to eq('/custom/path')
    end
    
    it 'initializes empty result structure' do
      result = parser.result
      
      expect(result).to be_a(Hash)
      expect(result[:title]).to eq("")
      expect(result[:description]).to eq("")
      expect(result[:examples]).to eq([])
    end
  end
  
  describe '#read_file' do
    context 'when file exists' do
      it 'reads the file content' do
        parser.read_file
        content = parser.instance_variable_get('@content')
        
        expect(content).to be_a(String)
        expect(content).to include('doc_title')
        expect(content).to include('Checkboxes')
      end
    end
    
    context 'when file does not exist' do
      let(:non_existent_file) { '/path/to/non/existent/file.haml' }
      let(:invalid_parser) { described_class.new(non_existent_file) }
      
      it 'raises an error' do
        expect { invalid_parser.read_file }.to raise_error(RuntimeError, /File does not exist/)
      end
    end
  end
  
  describe '#generate_ast' do
    before do
      parser.read_file
    end
    
    it 'generates an AST from the HAML content' do
      parser.generate_ast
      ast = parser.ast
      
      expect(ast).not_to be_nil
      expect(ast).to be_a(Haml::Parser::ParseNode)
      expect(ast.type).to eq(:root)
      expect(ast.children).to be_an(Array)
      expect(ast.children.length).to be > 0
    end
  end
  
  describe '#parse' do
    let(:parser) { Algolia::HamlParserService.new(file_path) }
    let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'example.html.haml') }
    
    it 'extracts title and description from doc_title blocks' do
      result = parser.parse
      expect(result[:title]).to eq('Checkboxes')
      
      # Markdown content is processed from the description
      expect(result[:description]).to include('These components support the following features:')
      expect(result[:description]).to include('Custom labels')
      expect(result[:description]).to include('Disabled state')
    end

    it 'extracts examples with titles, descriptions, and code' do
      result = parser.parse
      examples = result[:examples]
      
      expect(examples.length).to eq(2)
      
      # First example
      expect(examples[0][:title]).to eq('Basic Checkbox')
      expect(examples[0][:description]).to include('basic checkbox example with a label')
      expect(examples[0][:description]).to include('The checkbox requires the following attributes:')
      expect(examples[0][:description]).to include('`id` - Unique identifier')
      expect(examples[0][:code]).to include('render Daisy::DataInput::Checkbox.new')
      
      # Second example
      expect(examples[1][:title]).to eq('Disabled Checkbox')
      expect(examples[1][:description]).to include('checkbox can be disabled')
      expect(examples[1][:description]).to include('When disabled, the checkbox cannot be checked')
      expect(examples[1][:code]).to include('disabled: true')
    end
    
    context 'when file contains no doc_title' do
      let(:file_with_no_title) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'no_title.html.haml') }
      let(:no_title_parser) { described_class.new(file_with_no_title) }
      
      before do
        # Create a test HAML file with no doc_title
        File.write(file_with_no_title, <<~HAML)
          .example
            This is just regular HAML content
            %p No documentation here
        HAML
      end
      
      it 'returns an empty hash for title and description' do
        result = no_title_parser.parse
        
        expect(result[:title]).to eq("")
        expect(result[:description]).to eq("")
      end
    end
    
    context 'when an error occurs during parsing' do
      let(:invalid_haml_file) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'invalid.html.haml') }
      let(:error_parser) { described_class.new(invalid_haml_file) }
      
      before do
        # Create an invalid HAML file
        File.write(invalid_haml_file, <<~HAML)
          %div
              %p Indentation is wrong
            %span This will cause a parser error
        HAML
        
        allow(error_parser).to receive(:puts) # Suppress output
      end
      
      it 'handles errors gracefully and returns the default empty structure' do
        result = error_parser.parse
        
        expect(result).to be_a(Hash)
        expect(result[:title]).to eq("")
        expect(result[:description]).to eq("")
        expect(result[:examples]).to eq([])
      end
    end
  end
  
  describe 'helper methods' do
    describe '#is_doc_title?' do
      it 'correctly identifies doc_title nodes' do
        # Create a mock doc_title node
        doc_title_node = double(type: :script, value: { text: '= doc_title title: "Test"' })
        non_doc_title_node = double(type: :script, value: { text: '= regular_script' })
        
        # We need to use send to test private methods
        expect(parser.send(:is_doc_title?, doc_title_node)).to be true
        expect(parser.send(:is_doc_title?, non_doc_title_node)).to be false
      end
    end
    
    describe '#is_example_title?' do
      it 'correctly identifies example_title nodes' do
        # Create a mock example_title node
        example_title_node = double(type: :script, value: { text: '= doc_example title: "Test"' })
        non_example_title_node = double(type: :script, value: { text: '= regular_script' })
        
        expect(parser.send(:is_example_title?, example_title_node)).to be true
        expect(parser.send(:is_example_title?, non_example_title_node)).to be false
      end
    end
    
    describe '#is_example_description?' do
      it 'correctly identifies example_description nodes' do
        # Create a mock example_description node
        example_desc_node = double(type: :silent_script, value: { text: '- doc.with_description do' })
        non_example_desc_node = double(type: :silent_script, value: { text: '- regular_silent_script' })
        
        expect(parser.send(:is_example_description?, example_desc_node)).to be true
        expect(parser.send(:is_example_description?, non_example_desc_node)).to be false
      end
    end
    
    describe '#clean_title' do
      it 'extracts title from doc_title strings' do
        title_string = 'doc_title title: "Test Title"'
        
        cleaned_title = parser.send(:clean_title, title_string)
        expect(cleaned_title).to eq('Test Title')
      end
      
      it 'returns the original string if no title pattern is found' do
        title_string = 'No title pattern here'
        
        cleaned_title = parser.send(:clean_title, title_string)
        expect(cleaned_title).to eq('No title pattern here')
      end
      
      it 'handles blank strings correctly' do
        expect(parser.send(:clean_title, '')).to eq('')
        expect(parser.send(:clean_title, nil)).to eq(nil)
      end
    end
    
    describe '#clean_string' do
      it 'removes excessive whitespace and trims the string' do
        messy_string = "  This   has   too    many   spaces   "
        
        cleaned_string = parser.send(:clean_string, messy_string)
        expect(cleaned_string).to eq('This has too many spaces')
      end
      
      it 'returns an empty string for nil input' do
        expect(parser.send(:clean_string, nil)).to eq('')
      end
    end
  end
  
  describe 'parsing different HAML structures' do
    context 'with complex nested content' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'complex.html.haml') }
      
      it 'extracts the title and description correctly' do
        result = parser.parse
        
        expect(result[:title]).to eq('Complex Component')
        expect(result[:description]).to include('Features')
        expect(result[:description]).to include('Responsive design')
        expect(result[:description]).to include('Interactive elements')
        expect(result[:description]).to include('**Customizable**')
      end
      
      it 'extracts complex examples with nested content' do
        result = parser.parse
        examples = result[:examples]
        
        expect(examples.length).to eq(1)
        expect(examples[0][:title]).to eq('Nested Content Example')
        expect(examples[0][:description]).to include('deeply nested content')
        expect(examples[0][:description]).to include('The component supports these interactions:')
        expect(examples[0][:description]).to include('Click to toggle')
        expect(examples[0][:description]).to include('Make sure to include all required attributes')
        expect(examples[0][:code]).to include('card-header')
        expect(examples[0][:code]).to include('data: {controller: "card"')
      end
    end
    
    context 'with examples that have no descriptions' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'no_descriptions.html.haml') }
      
      it 'extracts examples without descriptions correctly' do
        result = parser.parse
        examples = result[:examples]
        
        expect(examples.length).to eq(2)
        expect(examples[0][:title]).to eq('No Description Example')
        expect(examples[0][:description]).to eq('')
        expect(examples[1][:title]).to eq('Another No Description')
        expect(examples[1][:description]).to eq('')
      end
    end
    
    context 'with special characters and UTF-8 content' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'special_chars.html.haml') }
      
      it 'handles special characters in title and description' do
        result = parser.parse
        
        expect(result[:title]).to eq('Special Characters & UTF-8 Test')
        expect(result[:description]).to include('Internationalization')
        expect(result[:description]).to include('Support for *international* characters')
        expect(result[:description]).to include('**essential**')
      end
      
      it 'preserves UTF-8 characters in examples' do
        result = parser.parse
        examples = result[:examples]
        
        expect(examples[0][:title]).to eq('UTF-8 Example')
        expect(examples[0][:description]).to include('emoji')
        expect(examples[0][:description]).to include('Thumbs up')
        expect(examples[0][:description]).to include('special chars')
        expect(examples[0][:code]).to include('Button.new')
      end
    end
    
    context 'with mixed regular content and documentation' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'mixed_content.html.haml') }
      
      it 'finds documentation blocks among regular content' do
        result = parser.parse
        
        expect(result[:title]).to eq('Mixed Content Example')
        expect(result[:description]).to include('Purpose')
        expect(result[:description]).to include('Regular page content')
        expect(result[:description]).to include('Documentation blocks')
        
        # Find the example with a title matching our expected example
        example = result[:examples].find { |ex| ex[:title] == 'Example After Regular Content' }
        expect(example).not_to be_nil
        expect(example[:description]).to include('appears after some non-documentation content')
        expect(example[:description]).to include('The parser should still be able to extract:')
        expect(example[:description]).to include('Example titles and descriptions')
      end
    end
    
    context 'with only comments' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'comments_only.html.haml') }
      
      it 'properly handles files with only comments' do
        result = parser.parse
        
        expect(result[:title]).to eq('')
        expect(result[:description]).to eq('')
        
        # The service might find examples from comments, but they should be empty or only have the comment text
        if !result[:examples].empty?
          result[:examples].each do |ex|
            expect(ex[:title]).to eq('')
            expect(ex[:description]).to eq('')
          end
        end
      end
    end
    
    context 'with an empty file' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'haml_parser', 'empty.html.haml') }
      
      it 'handles empty files gracefully' do
        result = parser.parse
        
        expect(result[:title]).to eq('')
        expect(result[:description]).to eq('')
        expect(result[:examples]).to be_empty
      end
    end
  end
end
