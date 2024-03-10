require "rails_helper"

RSpec.describe LocoMotion::Actions::FabComponent, type: :component do
  it "renders the component" do
    output = render_inline(described_class.new(css: "new_css")) do |fab|
      # Nothing here yet, but component slots / etc would go in here
    end

    expect(page).to have_css "button.new_css"
  end
end
