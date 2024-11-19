class Daisy::Layout::JoinComponent < LocoMotion::BaseComponent
  renders_many :items

  def before_render
    add_css(:component, "join")
  end

  def call
    part(:component) do
      items.each do |item|
        concat(item)
      end
    end
  end
end
