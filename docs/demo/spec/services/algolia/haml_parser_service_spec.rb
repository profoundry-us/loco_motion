# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Algolia::HamlParserService do
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
    # Allow all File.exist? calls, but return true specifically for our test file
    allow(File).to receive(:exist?).and_return(false)
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
      # This is redundant since we set a default for File.exist? above, but keeping it for clarity
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
      # This is redundant since we set a default for File.exist? above, but keeping it for clarity
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
  end
end
