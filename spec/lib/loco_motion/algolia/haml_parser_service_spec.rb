# frozen_string_literal: true

require 'spec_helper'
require 'loco_motion/algolia/haml_parser_service'

RSpec.describe LocoMotion::Algolia::HamlParserService do
  let(:file_content) do
    <<~HAML
      = doc_title(title: "Checkboxes") do |title|
        :markdown
          Here are some examples showcasing checkbox components.


      = doc_example(title: "Basic Checkboxes") do |doc|
        - doc.with_description do
          :markdown
            Checkboxes are used to select one or more options from a set.

        .my-2.flex.flex-col.gap-4
          = daisy_label(for: "checkbox1") do
            = daisy_checkbox(name: "checkbox1", id: "checkbox1")
            Default Checkbox

          = daisy_label(for: "checkbox2") do
            = daisy_checkbox(name: "checkbox2", id: "checkbox2", checked: true)
            Checked Checkbox


      = doc_example(title: "Checkboxes with Colors") do |doc|
        - doc.with_description do
          :markdown
            Checkboxes can be styled with different colors using DaisyUI's color classes.

          = doc_note(css: "mb-8") do
            :markdown
              Uses `checkbox-neutral` with dark backgrounds for dark mode compatibility.

        .my-2.grid.grid-cols-1.md:grid-cols-2.gap-4
          = daisy_label(for: "checkbox-dark") do
            = daisy_checkbox(name: "checkbox-dark", id: "checkbox-dark", css: "checkbox-neutral theme-controller", value: "dark", checked: false)
            Enable Dark Mode
    HAML
  end

  let(:file_path) { 'spec/fixtures/test_example.html.haml' }

  before do
    allow(File).to receive(:exist?).with(file_path).and_return(true)
    allow(File).to receive(:read).with(file_path).and_return(file_content)
  end

  describe "#initialize" do
    it "sets up the parser with default values" do
      parser = described_class.new(file_path)
      
      expect(parser.ast).to be_nil
      expect(parser.result).to eq({
        title: "",
        description: "",
        examples: []
      })
    end
    
    it "supports debug mode" do
      parser = described_class.new(file_path, true)
      
      expect(parser.instance_variable_get(:@debug)).to be true
    end
  end

  describe "#read_file" do
    it "returns nil when file doesn't exist" do
      nonexistent_file = 'nonexistent.html.haml'
      allow(File).to receive(:exist?).with(nonexistent_file).and_return(false)
      
      parser = described_class.new(nonexistent_file)
      expect(parser.read_file).to be_nil
    end

    it "reads the file content when file exists" do
      parser = described_class.new(file_path)
      expect(parser.read_file).to eq(file_content)
    end
  end

  describe "#parse" do
    subject(:parser) { described_class.new(file_path) }

    it "returns empty hash when file doesn't exist" do
      nonexistent_file = 'nonexistent.html.haml'
      allow(File).to receive(:exist?).with(nonexistent_file).and_return(false)
      
      parser = described_class.new(nonexistent_file)
      expect(parser.parse).to eq({})
    end

    it "extracts title and description from doc_title blocks" do
      result = parser.parse

      expect(result[:title]).to eq("Checkboxes")
      expect(result[:description]).to eq("Here are some examples showcasing checkbox components.")
    end

    it "extracts examples with titles, descriptions, and code" do
      result = parser.parse

      # There should be two examples
      expect(result[:examples].size).to eq(2)

      # Check the first example
      first_example = result[:examples][0]
      expect(first_example[:title]).to eq("Basic Checkboxes")
      expect(first_example[:description]).to eq("Checkboxes are used to select one or more options from a set.")
      expect(first_example[:code]).to include(".my-2.flex.flex-col.gap-4")
      expect(first_example[:code]).to include("daisy_checkbox(name: \"checkbox1\"")

      # Check the second example
      second_example = result[:examples][1]
      expect(second_example[:title]).to eq("Checkboxes with Colors")
      expect(second_example[:description]).to include("Checkboxes can be styled with different colors")
      expect(second_example[:code]).to include(".my-2.grid.grid-cols-1.md:grid-cols-2.gap-4")
      expect(second_example[:code]).to include("checkbox-neutral theme-controller")
    end
  end

  describe "#generate_ast" do
    it "parses the content and creates an AST" do
      parser = described_class.new(file_path)
      parser.generate_ast
      
      expect(parser.ast).not_to be_nil
      expect(parser.ast).to be_a(Haml::Parser::ParseNode)
    end
  end

  describe "#ast_hash" do
    it "converts AST to a hash representation without parent references" do
      parser = described_class.new(file_path)
      parser.generate_ast
      
      hash = parser.ast_hash
      expect(hash).to be_a(Hash)
      expect(hash).not_to have_key(:parent)
      expect(hash).to have_key(:children)
    end
  end

  describe "#process_ast" do
    it "extracts info from the AST nodes" do
      parser = described_class.new(file_path)
      parser.generate_ast
      parser.process_ast
      
      expect(parser.result[:title]).to eq("Checkboxes")
      expect(parser.result[:examples].size).to eq(2)
    end
  end

  describe "#clean_title" do
    it "extracts titles from strings containing title attributes" do
      parser = described_class.new(file_path)
      
      result = parser.clean_title('doc_title(title: "My Title")')
      expect(result).to eq("My Title")
    end
    
    it "returns the original string if no title pattern is found" do
      parser = described_class.new(file_path)
      
      result = parser.clean_title('Some text without a title pattern')
      expect(result).to eq('Some text without a title pattern')
    end
  end

  describe "#clean_string" do
    it "removes excess whitespace and trims the string" do
      parser = described_class.new(file_path)
      
      result = parser.clean_string("  This   has   extra   spaces  \n  and newlines  \n  ")
      expect(result).to eq("This has extra spaces and newlines")
    end
  end

  describe "#generate_code_from_tag" do
    it "generates HAML code for tag nodes" do
      parser = described_class.new(file_path)
      parser.generate_ast
      
      # Create a mock tag node for testing
      tag_node = double(
        type: :tag,
        value: {
          name: 'div',
          attributes: {'class' => 'test-class'},
          dynamic_attributes: nil,
          value: 'Test Content'
        }
      )
      
      result = parser.generate_code_from_tag(tag_node)
      expect(result).to eq('.test-class Test Content')
    end
    
    it "handles non-div tags correctly" do
      parser = described_class.new(file_path)
      
      tag_node = double(
        type: :tag,
        value: {
          name: 'span',
          attributes: {'class' => 'test-class'},
          dynamic_attributes: nil,
          value: ''
        }
      )
      
      result = parser.generate_code_from_tag(tag_node)
      expect(result).to eq('%span.test-class')
    end
  end

  context "with a file that has only doc_title but no examples" do
    let(:title_only_content) do
      <<~HAML
        = doc_title(title: "Just a Title") do |title|
          :markdown
            This page has a title but no examples.
      HAML
    end

    before do
      allow(File).to receive(:read).with(file_path).and_return(title_only_content)
    end
    
    subject(:parser) { described_class.new(file_path) }

    it "extracts the title and description but has no examples" do
      result = parser.parse

      expect(result[:title]).to eq("Just a Title")
      expect(result[:description]).to eq("This page has a title but no examples.")
      expect(result[:examples]).to be_empty
    end
  end

  context "with examples that have no description blocks" do
    let(:no_description_content) do
      <<~HAML
        = doc_title(title: "No Descriptions") do |title|
          :markdown
            Examples without descriptions.

        = doc_example(title: "Example Without Description") do |doc|
          .some-class
            This example has no description block.
      HAML
    end

    before do
      allow(File).to receive(:read).with(file_path).and_return(no_description_content)
    end
    
    subject(:parser) { described_class.new(file_path) }

    it "extracts the example with an empty description" do
      result = parser.parse

      expect(result[:examples].size).to eq(1)
      expect(result[:examples][0][:title]).to eq("Example Without Description")
      expect(result[:examples][0][:description]).to eq('')
      expect(result[:examples][0][:code]).to include(".some-class")
    end
  end

  context "when there are errors during parsing" do
    before do
      allow_any_instance_of(described_class).to receive(:generate_ast).and_raise(StandardError.new("Test error"))
    end
    
    subject(:parser) { described_class.new(file_path) }

    it "handles errors gracefully" do
      # Capture stdout to verify debug output
      allow($stdout).to receive(:puts)
      
      # Should not raise an error
      expect { parser.parse }.not_to raise_error
      
      # Should return the default result
      expect(parser.result).to eq({
        title: "",
        description: "",
        examples: []
      })
    end
  end
end
