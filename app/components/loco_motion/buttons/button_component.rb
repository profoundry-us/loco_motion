class LocoMotion::Buttons::ButtonComponent < LocoMotion.configuration.base_component_class
  define_part :outside
  define_part :inside

  erb_template <<-ERB
    <button class="btn">Regular Button</button>
  ERB
end
