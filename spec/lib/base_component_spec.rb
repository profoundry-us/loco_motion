require "rails_helper"

RSpec.describe LocoMotion::BaseComponent, type: :component do
  context "with a very basic inherited class" do
    class BasicComponent < LocoMotion::BaseComponent
      def call
        part(:component) do
          content
        end
      end
    end

    before do
      render_inline(BasicComponent.new)
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

      it "adds the component name to the component CSS" do
        expect(page).to have_css("div.some_name")
      end
    end

    context "with some extra parts" do
      class NamedComponent < LocoMotion::BaseComponent
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

      let(:named_component) { NamedComponent.new }

      context "render" do
        before do
          render_inline(named_component)
        end

        it "renders all three parts" do
          expect(page).to have_css("div.some_name div div")
        end
      end

      context "#rendered_css(:component)" do
        let(:css) { named_component.rendered_css(:component) }

        it "adds the component name to the CSS" do
          expect(css).to include("some_name")
        end
      end

      context "#rendered_css(:first)" do
        let(:css) { named_component.rendered_css(:first) }

        it "does not add the component name to the CSS" do
          expect(css).not_to include("some_name")
        end
      end

      context "#rendered_css(:second)" do
        let(:css) { named_component.rendered_css(:second) }

        it "does not add the component name to the CSS" do
          expect(css).not_to include("some_name")
        end
      end
    end

    context "with variants" do
      class VariantsComponent < LocoMotion::BaseComponent
        set_component_name :some_name

        define_variants :cool, :beans

        def call
          part(:component) do
            content
          end
        end
      end

      let(:variant1) { VariantsComponent.new(variant: :cool) }
      let(:variant2) { VariantsComponent.new(variant: :beans) }

      context "rendered_css(:component)" do
        let(:css1) { variant1.rendered_css(:component) }
        let(:css2) { variant2.rendered_css(:component) }

        it "adds the component name + variant to the CSS" do
          expect(css1).to include("some_name-cool")
          expect(css2).to include("some_name-beans")
        end

        it "does not add the other variant's CSS" do
          expect(css1).not_to include("some_name-beans")
          expect(css2).not_to include("some_name-cool")
        end

        # TODO: Add a check for variant names that have underscores (should translate to dashes)
        # TODO: Component names with underscores should probably also use dashes? Not sure if there are any in DaisyUI.
      end
    end
  end

end
