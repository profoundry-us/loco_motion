module Daisy
  COMPONENT_HELPERS = {
    # Actions
    button: 'Daisy::Actions::ButtonComponent',
    modal: 'Daisy::Actions::ModalComponent',

    # Data
    accordion: 'Daisy::DataDisplay::AccordionComponent',
    avatar: 'Daisy::DataDisplay::AvatarComponent',
    badge: 'Daisy::DataDisplay::BadgeComponent',
    diff: 'Daisy::DataDisplay::DiffComponent',
    kbd: 'Daisy::DataDisplay::KbdComponent',
    stat: 'Daisy::DataDisplay::StatComponent',
    table: 'Daisy::DataDisplay::TableComponent',
  }

  module Helpers
    COMPONENT_HELPERS.each do |method_name, component_klass|
      ActionView::Helpers.define_method("daisy_#{method_name}") do |*args, **kws, &block|
        render(component_klass.constantize.new(*args, **kws), &block)
      end
    end
  end
end
