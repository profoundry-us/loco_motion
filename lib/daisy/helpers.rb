module Daisy
  COMPONENT_HELPERS = {
    # TODO: The hero icons should be in a different helper? Or maybe this whole
    # thing should be in a Loco module instead of Daisy?

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
    countdown: "Daisy::DataDisplay::CountdownComponent",
    diff: "Daisy::DataDisplay::DiffComponent",
    kbd: "Daisy::DataDisplay::KbdComponent",
    stat: "Daisy::DataDisplay::StatComponent",
    table: "Daisy::DataDisplay::TableComponent",
    timeline: "Daisy::DataDisplay::TimelineComponent",

    # Navigation
    breadcrumbs: "Daisy::Navigation::BreadcrumbsComponent",
    link: "Daisy::Navigation::LinkComponent",
    menu: "Daisy::Navigation::MenuComponent",
    navbar: "Daisy::Navigation::NavbarComponent",
    # TODO: This doesn't exist as a component, so it feels weird to have it
    # here; but it makes the navigation work properly.
    pagination: "Daisy::Navigation::PaginationComponent",
    steps: "Daisy::Navigation::StepsComponent",
    tabs: "Daisy::Navigation::TabsComponent",

    # Feedback
    alert: "Daisy::Feedback::AlertComponent",

    # Layout
    join: "Daisy::Layout::JoinComponent",
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
