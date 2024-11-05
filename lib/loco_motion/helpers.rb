module LocoMotion
  COMPONENTS = {
    ### Hero Components

    "Hero::IconComponent" => { names: "icon", group: "Hero", title: "Icons", example: "icons" },

    ### Daisy Components

    # Actions
    "Daisy::Actions::ButtonComponent" => { names: "button", group: "Actions", title: "Buttons", example: "buttons" },
    "Daisy::Actions::DropdownComponent" => { names: "dropdown", group: "Actions", title: "Dropdowns", example: "dropdowns" },
    "Daisy::Actions::ModalComponent" => { names: "modal", group: "Actions", title: "Modals", example: "modals" },
    "Daisy::Actions::SwapComponent" => { names: "swap", group: "Actions", title: "Swaps", example: "swaps" },
    "Daisy::Actions::ThemeControllerComponent" => { names: "theme_controller", group: "Actions", title: "Theme Controllers", example: "theme_controllers" },

    # Data
    "Daisy::DataDisplay::AccordionComponent" => { names: "accordion", group: "Data", title: "Accordions", example: "accordions" },
    "Daisy::DataDisplay::AvatarComponent" => { names: "avatar", group: "Data", title: "Avatars", example: "avatars" },
    "Daisy::DataDisplay::BadgeComponent" => { names: "badge", group: "Data", title: "Badges", example: "badges" },
    "Daisy::DataDisplay::CardComponent" => { names: "card", group: "Data", title: "Cards", example: "cards" },
    "Daisy::DataDisplay::CarouselComponent" => { names: "carousel", group: "Data", title: "Carousels", example: "carousels" },
    "Daisy::DataDisplay::ChatComponent" => { names: "chat", group: "Data", title: "Chat Bubbles", example: "chat_bubbles" },
    "Daisy::DataDisplay::CollapseComponent" => { names: "collapse", group: "Data", title: "Collapses", example: "collapses" },
    "Daisy::DataDisplay::CountdownComponent" => { names: "countdown", group: "Data", title: "Countdowns", example: "countdowns" },
    "Daisy::DataDisplay::DiffComponent" => { names: "diff", group: "Data", title: "Diffs", example: "diffs" },
    "Daisy::DataDisplay::KbdComponent" => { names: "kbd", group: "Data", title: "Keyboard (KBD)", example: "kbds" },
    "Daisy::DataDisplay::StatComponent" => { names: "stat", group: "Data", title: "Stats", example: "stats" },
    "Daisy::DataDisplay::TableComponent" => { names: "table", group: "Data", title: "Tables", example: "tables" },
    "Daisy::DataDisplay::TimelineComponent" => { names: "timeline", group: "Data", title: "Timelines", example: "timelines" },

    # Navigation
    "Daisy::Navigation::BreadcrumbsComponent" => { names: "breadcrumbs", group: "Navigation", title: "Breadcrumbs", example: "breadcrumbs" },
    "Daisy::Navigation::BottomNavComponent" => { names: "bottom_nav", group: "Navigation", title: "Bottom Navs", example: "bottom_navs" },
    "Daisy::Navigation::LinkComponent" => { names: "link", group: "Navigation", title: "Links", example: "links" },
    "Daisy::Navigation::MenuComponent" => { names: "menu", group: "Navigation", title: "Menus", example: "menus" },
    "Daisy::Navigation::NavbarComponent" => { names: "navbar", group: "Navigation", title: "Navbars", example: "navbars" },
    "Daisy::Navigation::PaginationComponent" => { names: "pagination", group: "Navigation", title: "Pagination", example: "pagination" },
    "Daisy::Navigation::StepsComponent" => { names: "steps", group: "Navigation", title: "Steps", example: "steps" },
    "Daisy::Navigation::TabsComponent" => { names: "tabs", group: "Navigation", title: "Tabs", example: "tabs" },

    # Feedback
    "Daisy::Feedback::AlertComponent" => { names: "alert", group: "Feedback", title: "Alerts", example: "alerts" },
    "Daisy::Feedback::LoadingComponent" => { names: ["loading", "loader"], group: "Feedback", title: "Loaders", example: "loaders" },
    "Daisy::Feedback::ProgressComponent" => { names: ["progress"], group: "Feedback", title: "Progress Bars", example: "progress_bars" },
    "Daisy::Feedback::RadialProgressComponent" => { names: "radial", group: "Feedback", title: "Radial Progress", example: "radials" },
    "Daisy::Feedback::SkeletonComponent" => { names: "skeleton", group: "Feedback", title: "Skeletons", example: "skeletons" },

    # Layout
    "Daisy::Layout::JoinComponent" => { names: "join", group: "Layout", title: "Joins", example: "joins" },
  }

  module Helpers
    COMPONENTS.each do |component, helper|
      framework = component.split("::").first.underscore

      method_names = [helper[:names]].flatten

      method_names.each do |method_name|
        ActionView::Helpers.define_method("#{framework}_#{method_name}") do |*args, **kws, &block|
          render(component.constantize.new(*args, **kws), &block)
        end
      end
    end

    def component_example_path(component_name)
      comp = COMPONENTS[component_name]

      comp_split = component_name.split("::")
      framework = comp_split.first.underscore
      section = comp_split.length == 3 ? comp_split[1] : nil
      example = comp[:example]
      section_path = section ? "#{section.underscore}/" : ""

      "/examples/#{framework}/#{section_path}#{example}"
    end

    module_function :component_example_path
  end
end
