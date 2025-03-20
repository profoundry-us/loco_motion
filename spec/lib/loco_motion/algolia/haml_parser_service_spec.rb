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

  describe "#parse" do
    subject(:parser) { described_class.new(file_path) }

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
      expect(second_example[:description]).to eq("Checkboxes can be styled with different colors using DaisyUI's color classes.")
      expect(second_example[:code]).to include(".my-2.grid.grid-cols-1.md:grid-cols-2.gap-4")
      expect(second_example[:code]).to include("checkbox-neutral theme-controller")
    end

    context "with a file that doesn't exist" do
      let(:nonexistent_file) { 'nonexistent.html.haml' }

      before do
        allow(File).to receive(:exist?).with(nonexistent_file).and_return(false)
      end

      it "returns an empty hash" do
        parser = described_class.new(nonexistent_file)
        result = parser.parse

        expect(result).to eq({})
      end
    end

    context "with a file that has no doc blocks" do
      let(:empty_content) { "<p>Just some HTML without doc blocks</p>" }

      before do
        allow(File).to receive(:read).with(file_path).and_return(empty_content)
      end

      it "returns a hash with empty values" do
        result = parser.parse

        expect(result[:title]).to be_nil
        expect(result[:description]).to be_nil
        expect(result[:examples]).to be_empty
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

      it "extracts the title and description but has no examples" do
        result = parser.parse

        expect(result[:title]).to eq("Just a Title")
        expect(result[:description]).to eq("This page has a title but no examples.")
        expect(result[:examples]).to be_empty
      end
    end

    context "with examples that have no descriptions" do
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

      it "extracts the example with an empty description" do
        result = parser.parse

        expect(result[:examples].size).to eq(1)
        expect(result[:examples][0][:title]).to eq("Example Without Description")
        expect(result[:examples][0][:description]).to eq('')
        expect(result[:examples][0][:code]).to include(".some-class")
      end
    end
  end
end
