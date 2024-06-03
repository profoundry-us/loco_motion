module Daisy
  COMPONENT_HELPERS = {
    # Actions
    button: 'Daisy::Actions::ButtonComponent',
    fab: 'Daisy::Actions::FabComponent',
    modal: 'Daisy::Actions::ModalComponent',

    # Data
    badge: 'Daisy::Data::BadgeComponent',
  }

  module Helpers
    COMPONENT_HELPERS.each do |method_name, component_klass|
      ActionView::Helpers.define_method("daisy_#{method_name}") do |*args, **kws, &block|
        render(component_klass.constantize.new(*args, **kws), &block)
      end
    end
  end
end