class LocoMotion::Actions::FabComponent < LocoMotion.configuration.base_component_class
  define_part :outside, tag_name: :button
  define_part :inside, tag_name: :span

  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :button)

    add_css(:component, "btn btn-circle")
    add_html(:component, { foo: 'bar' })

    add_css(:inside, "woot ha-ha-ha")

    add_stimulus_controller(:component, :test_controller)
    add_stimulus_controller(:outside, :outside_controller)
    add_stimulus_controller(:inside, :inside_controller)
  end
end
