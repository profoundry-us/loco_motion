module Daisy
  COMPONENT_HELPERS = {
    ### Hero Icons
    icon: "Hero::IconComponent",

    ### Daisy Components

    # Actions
    button: "Daisy::Actions::ButtonComponent",
    dropdown: "Daisy::Actions::DropdownComponent",
    modal: "Daisy::Actions::ModalComponent",
    swap: "Daisy::Actions::SwapComponent",
    theme_controller: "Daisy::Actions::ThemeControllerComponent",

    # Data
    accordion: "Daisy::DataDisplay::AccordionComponent",
    avatar: "Daisy::DataDisplay::AvatarComponent",
    badge: "Daisy::DataDisplay::BadgeComponent",
    card: "Daisy::DataDisplay::CardComponent",
    carousel: "Daisy::DataDisplay::CarouselComponent",
    chat: "Daisy::DataDisplay::ChatComponent",
    collapse: "Daisy::DataDisplay::CollapseComponent",
    diff: "Daisy::DataDisplay::DiffComponent",
    kbd: "Daisy::DataDisplay::KbdComponent",
    stat: "Daisy::DataDisplay::StatComponent",
    table: "Daisy::DataDisplay::TableComponent",

    # Navigation
    tabs: "Daisy::Navigation::TabsComponent",
  }

  module Helpers
    COMPONENT_HELPERS.each do |method_name, component_klass|
      framework = component_klass.split("::").first.downcase

      ActionView::Helpers.define_method("#{framework}_#{method_name}") do |*args, **kws, &block|
        render(component_klass.constantize.new(*args, **kws), &block)
      end
    end
  end
end
