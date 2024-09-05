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
      end
    end
  end

end
