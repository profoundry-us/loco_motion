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
    end
  end

end
