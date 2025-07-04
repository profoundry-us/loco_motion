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
    "Daisy::DataDisplay::AccordionComponent" => { names: "accordion", group: "Data Display", title: "Accordions", example: "accordions" },
    "Daisy::DataDisplay::AvatarComponent" => { names: "avatar", group: "Data Display", title: "Avatars", example: "avatars" },
    "Daisy::DataDisplay::BadgeComponent" => { names: "badge", group: "Data Display", title: "Badges", example: "badges" },
    "Daisy::DataDisplay::CardComponent" => { names: "card", group: "Data Display", title: "Cards", example: "cards" },
    "Daisy::DataDisplay::CarouselComponent" => { names: "carousel", group: "Data Display", title: "Carousels", example: "carousels" },
    "Daisy::DataDisplay::ChatComponent" => { names: "chat", group: "Data Display", title: "Chat Bubbles", example: "chat_bubbles" },
    "Daisy::DataDisplay::CollapseComponent" => { names: "collapse", group: "Data Display", title: "Collapses", example: "collapses" },
    "Daisy::DataDisplay::CountdownComponent" => { names: "countdown", group: "Data Display", title: "Countdowns", example: "countdowns" },
    "Daisy::DataDisplay::DiffComponent" => { names: "diff", group: "Data Display", title: "Diffs", example: "diffs" },
    "Daisy::DataDisplay::FigureComponent" => { names: "figure", group: "Data Display", title: "Figures", example: "figures" },
    "Daisy::DataDisplay::KbdComponent" => { names: "kbd", group: "Data Display", title: "Keyboard (KBD)", example: "kbds" },
    "Daisy::DataDisplay::ListComponent" => { names: "list", group: "Data Display", title: "Lists", example: "lists" },
    "Daisy::DataDisplay::StatComponent" => { names: "stat", group: "Data Display", title: "Stats", example: "stats" },
    "Daisy::DataDisplay::StatusComponent" => { names: "status", group: "Data Display", title: "Statuses", example: "statuses" },
    "Daisy::DataDisplay::TableComponent" => { names: "table", group: "Data Display", title: "Tables", example: "tables" },
    "Daisy::DataDisplay::TimelineComponent" => { names: "timeline", group: "Data Display", title: "Timelines", example: "timelines" },

    # Data Input
    "Daisy::DataInput::CallyComponent" => { names: "cally", group: "Data Input", title: "Calendars", example: "calendars" },
    "Daisy::DataInput::CallyInputComponent" => { names: "cally_input", group: "Data Input", title: "Cally Inputs", example: "cally_inputs" },
    "Daisy::DataInput::CheckboxComponent" => { names: "checkbox", group: "Data Input", title: "Checkboxes", example: "checkboxes" },
    "Daisy::DataInput::FileInputComponent" => { names: "file_input", group: "Data Input", title: "File Inputs", example: "file_inputs" },
    "Daisy::DataInput::FieldsetComponent" => { names: "fieldset", group: "Data Input", title: "Fieldsets", example: "fieldsets" },
    "Daisy::DataInput::FilterComponent" => { names: "filter", group: "Data Input", title: "Filters", example: "filters" },
    "Daisy::DataInput::LabelComponent" => { names: "label", group: "Data Input", title: "Labels", example: "labels" },
    "Daisy::DataInput::RadioButtonComponent" => { names: "radio", group: "Data Input", title: "Radio Buttons", example: "radio_buttons" },
    "Daisy::DataInput::RangeComponent" => { names: "range", group: "Data Input", title: "Ranges", example: "ranges" },
    "Daisy::DataInput::RatingComponent" => { names: "rating", group: "Data Input", title: "Ratings", example: "ratings" },
    "Daisy::DataInput::SelectComponent" => { names: "select", group: "Data Input", title: "Selects", example: "selects" },
    "Daisy::DataInput::TextInputComponent" => { names: ["input", "text_input"], group: "Data Input", title: "Text Inputs", example: "text_inputs" },
    "Daisy::DataInput::TextAreaComponent" => { names: "text_area", group: "Data Input", title: "Text Areas", example: "text_areas" },
    "Daisy::DataInput::ToggleComponent" => { names: "toggle", group: "Data Input", title: "Toggles", example: "toggles" },

    # Navigation
    "Daisy::Navigation::BreadcrumbsComponent" => { names: "breadcrumbs", group: "Navigation", title: "Breadcrumbs", example: "breadcrumbs" },
    "Daisy::Navigation::DockComponent" => { names: "dock", group: "Navigation", title: "Dock", example: "docks" },
    "Daisy::Navigation::LinkComponent" => { names: "link", group: "Navigation", title: "Links", example: "links" },
    "Daisy::Navigation::MenuComponent" => { names: "menu", group: "Navigation", title: "Menus", example: "menus" },
    "Daisy::Navigation::NavbarComponent" => { names: "navbar", group: "Navigation", title: "Navbars", example: "navbars" },
    "Daisy::Navigation::PaginationComponent" => { names: nil, group: "Navigation", title: "Pagination", example: "pagination" },
    "Daisy::Navigation::StepsComponent" => { names: "steps", group: "Navigation", title: "Steps", example: "steps" },
    "Daisy::Navigation::TabsComponent" => { names: "tabs", group: "Navigation", title: "Tabs", example: "tabs" },

    # Feedback
    "Daisy::Feedback::AlertComponent" => { names: "alert", group: "Feedback", title: "Alerts", example: "alerts" },
    "Daisy::Feedback::LoadingComponent" => { names: ["loading", "loader"], group: "Feedback", title: "Loaders", example: "loaders" },
    "Daisy::Feedback::ProgressComponent" => { names: ["progress"], group: "Feedback", title: "Progress Bars", example: "progress_bars" },
    "Daisy::Feedback::RadialProgressComponent" => { names: "radial", group: "Feedback", title: "Radial Progress", example: "radials" },
    "Daisy::Feedback::SkeletonComponent" => { names: "skeleton", group: "Feedback", title: "Skeletons", example: "skeletons" },
    "Daisy::Feedback::ToastComponent" => { names: "toast", group: "Feedback", title: "Toasts", example: "toasts" },
    "Daisy::Feedback::TooltipComponent" => { names: ["tooltip", "tip"], group: "Feedback", title: "Tooltips", example: "tooltips" },

    # Layout
    "Daisy::Layout::DividerComponent" => { names: "divider", group: "Layout", title: "Dividers", example: "dividers" },
    "Daisy::Layout::DrawerComponent" => { names: "drawer", group: "Layout", title: "Drawers", example: "drawers" },
    "Daisy::Layout::FooterComponent" => { names: "footer", group: "Layout", title: "Footers", example: "footers" },
    "Daisy::Layout::HeroComponent" => { names: "hero", group: "Layout", title: "Heroes", example: "heroes" },
    "Daisy::Layout::IndicatorComponent" => { names: "indicator", group: "Layout", title: "Indicators", example: "indicators" },
    "Daisy::Layout::JoinComponent" => { names: "join", group: "Layout", title: "Joins", example: "joins" },
    "Daisy::Layout::MaskComponent" => { names: nil, group: "Layout", title: "Masks", example: "masks" },
    "Daisy::Layout::StackComponent" => { names: "stack", group: "Layout", title: "Stacks", example: "stacks" },

    # Mockup
    "Daisy::Mockup::BrowserComponent" => { names: "browser", group: "Mockup", title: "Browsers", example: "browsers" },
    "Daisy::Mockup::CodeComponent" => { names: "code", group: "Mockup", title: "Code Blocks", example: "code_blocks" },
    "Daisy::Mockup::DeviceComponent" => { names: "device", group: "Mockup", title: "Devices", example: "devices" },
    "Daisy::Mockup::FrameComponent" => { names: "frame", group: "Mockup", title: "Frames", example: "frames" },
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
      "/examples/#{component_name}"
    end

    def component_partial_path(component_name)
      comp = COMPONENTS[component_name]

      comp_split = component_name.split("::")
      framework = comp_split.first.underscore
      section = comp_split.length == 3 ? comp_split[1] : nil
      example = comp[:example]
      section_path = section ? "#{section.underscore}/" : ""

      "/examples/#{framework}/#{section_path}#{example}"
    end

    module_function :component_example_path, :component_partial_path
  end
end
