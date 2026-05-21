require "rails_helper"

RSpec.describe LocoMotion::BaseComponent, type: :component do
  context "with a very simple inherited class" do
    class SimpleComponent1 < LocoMotion::BaseComponent
      def call
        part(:component) do
          content
        end
      end
    end

    before do
      render_inline(SimpleComponent1.new)
    end

    it "renders a div with no css" do
      expect(page).to have_css("div[class='']")

      #
      # If you want to inspect the page output, you can use puts or just run an
      # expectation against the page.native.inner_html:
      #
      # puts page.native.inner_html
      # expect(page.native.inner_html).to eq(nil)
    end
  end

  context "with a component name" do
    context "with no extra parts" do
      class NamedComponent < LocoMotion::BaseComponent
        set_component_name :some_name

        def call
          part(:component) do
            content
          end
        end
      end

      before do
        render_inline(NamedComponent.new)
      end

      it "does not add the component name to the component CSS" do
        expect(page).not_to have_css("div.some_name")
      end
    end

    context "with some extra parts" do
      class PartfulComponent < LocoMotion::BaseComponent
        set_component_name :some_name

        define_parts :first, :second

        def call
          part(:component) do
            part(:first) do
              part(:second) do
                content
              end
            end
          end
        end
      end

      let(:partful_component) { PartfulComponent.new(css: "comp", first_css: "first", second_css: "second") }

      context "render" do
        before do
          render_inline(partful_component)
        end

        it "renders all three parts" do
          expect(page).to have_css("div.comp div.first div.second")
        end
      end
    end

    context "with parts that have no block" do
      class NonBlockPartComponent < LocoMotion::BaseComponent
        define_part :nonblock

        def call
          part(:component) do
            part(:nonblock)
          end
        end
      end

      let(:nonblock_component) { NonBlockPartComponent.new(css: "comp", nonblock_css: "nonblock") }

      context "render" do
        before do
          render_inline(nonblock_component)
        end

        it "renders the HTML attributes properly" do
          expect(page).to have_css("div.comp div.nonblock")
        end

        it "does not render the attributes as text" do
          expect(page).not_to have_text("{:class=>\"nonblock\", :data=>{}}")
        end

        # If you pass a :div tag to the
        it "renders a comment to force a closing HTML tag" do
          expect(page).to have_xpath("//div[contains(@class,'nonblock')]//comment()[contains(.,'Empty Part Block')]")
        end
      end
    end
  end

  context "with initializer and setup hooks" do
    # Define a dummy module to act like a concern
    module DummyHookable
      extend ActiveSupport::Concern

      included do
        # Register methods using symbols
        register_component_initializer :_initialize_dummy
        register_component_setup :_setup_dummy
      end

      protected

      def _initialize_dummy
        @dummy_initialized_value = config_option(:dummy_init_data, "init_default")
      end

      def _setup_dummy
        @dummy_setup_value = "set_in_setup"
        add_html(:component, { data: { initialized: @dummy_initialized_value, setup: @dummy_setup_value } })
      end
    end

    # Define a component that includes the dummy module and registers its own hooks
    class HookedComponent < LocoMotion::BaseComponent
      include DummyHookable

      register_component_initializer :_initialize_direct
      register_component_setup :_setup_direct

      def call
        part(:component) { "Hooked Component Content" }
      end

      protected

      def _initialize_direct
        @direct_initialized = true
      end

      def _setup_direct
        @direct_setup = true
        add_css(:component, "direct-setup-applied")
      end
    end

    let(:init_data) { "passed_init_data" }
    let(:component) { HookedComponent.new(dummy_init_data: init_data) }

    it "runs registered initializers during initialization" do
      # Trigger initialization by creating the component instance
      component
      # Check instance variables set by initializers
      expect(component.instance_variable_get(:@dummy_initialized_value)).to eq(init_data)
      expect(component.instance_variable_get(:@direct_initialized)).to be true
    end

    context "when rendered" do
      before do
        render_inline(component)
      end

      it "runs registered setup methods before rendering" do
        # Check instance variables set by setup methods after render
        expect(component.instance_variable_get(:@dummy_setup_value)).to eq("set_in_setup")
        expect(component.instance_variable_get(:@direct_setup)).to be true
      end

      it "applies changes made by setup methods to the output" do
        # Check HTML attributes/CSS added by setup methods
        expect(page).to have_css("div[data-initialized='#{init_data}'][data-setup='set_in_setup']")
        expect(page).to have_css("div.direct-setup-applied")
      end
    end
  end

  context ".build method" do
    class BuildableComponent < LocoMotion::BaseComponent
      def initialize(**kws)
        super

        @custom_option = config_option(:custom_option, "default")
        @another_option = config_option(:another_option, nil)
      end

      def call
        part(:component) do
          content
        end
      end
    end

    context "creating a customized component" do
      it "creates a named subclass" do
        built_class = BuildableComponent.build(custom_option: "built_value")
        expect(built_class.name).to include("BuildableComponent__Build")
        expect(built_class.name).not_to eq(BuildableComponent.name)
      end

      it "creates a different name for each build" do
        built_class1 = BuildableComponent.build(custom_option: "value1")
        built_class2 = BuildableComponent.build(custom_option: "value2")
        expect(built_class1.name).not_to eq(built_class2.name)
      end
    end

    context "with build_kws" do
      it "merges build_kws into the config" do
        built_class = BuildableComponent.build(custom_option: "built_value")
        component = built_class.new
        expect(component.instance_variable_get(:@custom_option)).to eq("built_value")
      end

      it "allows instance_kws to override build_kws" do
        built_class = BuildableComponent.build(custom_option: "built_value")
        component = built_class.new(custom_option: "instance_value")
        expect(component.instance_variable_get(:@custom_option)).to eq("built_value")
      end

      it "updates instance variables for build_kws" do
        built_class = BuildableComponent.build(custom_option: "built_value", another_option: "another_value")
        component = built_class.new
        expect(component.instance_variable_get(:@custom_option)).to eq("built_value")
        expect(component.instance_variable_get(:@another_option)).to eq("another_value")
      end

      it "does not create instance variables for non-existent keys" do
        built_class = BuildableComponent.build(non_existent: "value")
        component = built_class.new
        expect(component.instance_variable_defined?(:@non_existent)).to be false
      end
    end

    context "with skip_styling" do
      class SkipStylableComponent < LocoMotion::BaseComponent
        def call
          part(:component) { content }
        end
      end

      it "defaults skip_styling to false when not set" do
        built_class = SkipStylableComponent.build
        component = built_class.new
        expect(component.instance_variable_get(:@skip_styling)).to be false
      end

      it "sets skip_styling to true when passed via build" do
        built_class = SkipStylableComponent.build(skip_styling: true)
        component = built_class.new
        expect(component.instance_variable_get(:@skip_styling)).to be true
      end

      it "sets skip_styling to true when passed via instance" do
        built_class = SkipStylableComponent.build
        component = built_class.new(skip_styling: true)
        expect(component.instance_variable_get(:@skip_styling)).to be true
      end
    end

    context "with sidecar_files delegation" do
      it "delegates sidecar_files to superclass" do
        built_class = BuildableComponent.build(custom_option: "value")
        expect(built_class).to respond_to(:sidecar_files)
      end
    end
  end

end
