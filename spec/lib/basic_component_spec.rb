require "rails_helper"

RSpec.describe LocoMotion::BasicComponent, type: :component do
  context "with a very simple inherited class" do
    class SimpleComponent2 < LocoMotion::BasicComponent
    end

    before do
      render_inline(SimpleComponent2.new) do
        "Content"
      end
    end

    it "renders a div with no css" do
      expect(page).to have_css("div[class='']")
    end

    it "renders the content" do
      expect(page).to have_text("Content")
    end

    it "has a default name" do
      expect(SimpleComponent2.name).to eq("BasicComponent")
    end
  end

  describe ".build" do
    context "with a simple component" do
      let(:simple) { described_class.build(tag_name: :span, css: "some-class", html: { data: { some: "value" } }) }

      before do
        render_inline(simple.new)
      end

      it "renders a span" do
        expect(page).to have_css("span")
      end

      it "renders the classes" do
        expect(page).to have_css("span.some-class")
      end

      it "renders the data attributes" do
        expect(page).to have_css("span[data-some='value']")
      end
    end

    context "with a complex component" do
      let(:complex) do
        described_class.build do
          define_part :wrapper

          renders_one :some_slot

          def before_render
            add_css(:component, "comp-class")
            add_css(:wrapper, "wrapper-class")
          end

          def call
            part(:component) do
              part(:wrapper) do
                [some_slot, content].join(' ').html_safe
              end
            end
          end
        end
      end

      before do
        render_inline(complex.new) do |c|
          c.with_some_slot(tag_name: :h2) { "Slot" }

          "Content"
        end
      end

      it "renders the component class from before_render" do
        expect(page).to have_css("div.comp-class")
      end

      it "renders the wrapper part class from before_render" do
        expect(page).to have_css("div.wrapper-class")
      end

      it "renders the slot" do
        expect(page).to have_css("div h2", text: "Slot")
      end

      it "renders the content" do
        expect(page).to have_text("Content")
      end
    end
  end
end
