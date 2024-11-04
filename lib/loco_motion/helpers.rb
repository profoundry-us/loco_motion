module LocoMotion
  COMPONENTS = [
    ### Hero Icons
    { name: "icon", group: "Hero", title: "Icons", component: "Hero::IconComponent" },

    ### Daisy Components

    # Actions
    { name: "button", group: "Actions", title: "Buttons", component: "Daisy::Actions::ButtonComponent" },
    { name: "dropdown", group: "Actions", title: "Dropdowns", component: "Daisy::Actions::DropdownComponent" },
    { name: "modal", group: "Actions", title: "Modals", component: "Daisy::Actions::ModalComponent" },
    { name: "swap", group: "Actions", title: "Swaps", component: "Daisy::Actions::SwapComponent" },
    { name: "theme_controller", group: "Actions", title: "Theme Controller", component: "Daisy::Actions::ThemeControllerComponent" },

    # Data
    { name: "accordion", group: "Data", title: "Accordions", component: "Daisy::DataDisplay::AccordionComponent" },
    { name: "avatar", group: "Data", title: "Avatars", component: "Daisy::DataDisplay::AvatarComponent" },
    { name: "badge", group: "Data", title: "Badges", component: "Daisy::DataDisplay::BadgeComponent" },
    { name: "card", group: "Data", title: "Cards", component: "Daisy::DataDisplay::CardComponent" },
    { name: "carousel", group: "Data", title: "Carousels", component: "Daisy::DataDisplay::CarouselComponent" },
    { name: "chat", group: "Data", title: "Chat Bubbles", component: "Daisy::DataDisplay::ChatComponent" },
    { name: "collapse", group: "Data", title: "Collapses", component: "Daisy::DataDisplay::CollapseComponent" },
    { name: "countdown", group: "Data", title: "Countdowns", component: "Daisy::DataDisplay::CountdownComponent" },
    { name: "diff", group: "Data", title: "Diffs", component: "Daisy::DataDisplay::DiffComponent" },
    { name: "kbd", group: "Data", title: "Keyboard (KBD)", component: "Daisy::DataDisplay::KbdComponent" },
    { name: "stat", group: "Data", title: "Stats", component: "Daisy::DataDisplay::StatComponent" },
    { name: "table", group: "Data", title: "Tables", component: "Daisy::DataDisplay::TableComponent" },
    { name: "timeline", group: "Data", title: "Timelines", component: "Daisy::DataDisplay::TimelineComponent" },

    # Navigation
    { name: "breadcrumbs", group: "Navigation", title: "Breadcrumbs", component: "Daisy::Navigation::BreadcrumbsComponent" },
    { name: "bottom_nav", group: "Navigation", title: "Bottom Navs", component: "Daisy::Navigation::BottomNavComponent" },
    { name: "link", group: "Navigation", title: "Links", component: "Daisy::Navigation::LinkComponent" },
    { name: "menu", group: "Navigation", title: "Menus", component: "Daisy::Navigation::MenuComponent" },
    { name: "navbar", group: "Navigation", title: "Navbars", component: "Daisy::Navigation::NavbarComponent" },
    { name: "pagination", group: "Navigation", title: "Pagination", component: "Daisy::Navigation::PaginationComponent" },
    { name: "steps", group: "Navigation", title: "Steps", component: "Daisy::Navigation::StepsComponent" },
    { name: "tabs", group: "Navigation", title: "Tabs", component: "Daisy::Navigation::TabsComponent" },

    # Feedback
    { name: "alert", group: "Feedback", title: "Alerts", component: "Daisy::Feedback::AlertComponent" },

    # Layout
    { name: "join", group: "Layout", title: "Joins", component: "Daisy::Layout::JoinComponent" },
  ]

  module Helpers
    COMPONENTS.each do |helper|
      framework = helper[:component].split("::").first.downcase

      ActionView::Helpers.define_method("#{framework}_#{helper[:name]}") do |*args, **kws, &block|
        render(helper[:component].constantize.new(*args, **kws), &block)
      end
    end
  end
end
