# Component Hook System Implementation

## Overview

Currently, components that use concerns like `TippableComponent` need to
explicitly call initialization and setup methods in their `initialize` and
`before_render` methods. This adds boilerplate code to each component and
requires developers to remember to add these calls when creating new components.

This plan outlines a strategy for implementing a hook system within the
`BaseComponent` class that will streamline how concerns are incorporated into
components. Instead of manually calling initialization and setup methods in each
component, concerns will register hooks that the `BaseComponent` will
automatically invoke at the appropriate lifecycle stages.

## External Resources

- [Rails ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
- [ViewComponent Lifecycle](https://viewcomponent.org/guide/lifecycle.html)

## Implementation Steps

### 1. Update BaseComponent with Hook Registration

**Purpose**: Add hook registration and execution capabilities to the base component.

**File to Edit**: `lib/loco_motion/base_component.rb`

**Changes**:
- Add class attributes for storing registered hooks
- Add methods for registering hooks
- Enhance initialization and before_render to invoke hooks
- Add a setup_component method that's called from before_render

```ruby
class LocoMotion::BaseComponent < ViewComponent::Base
  # Class-level storage for registered hooks
  class_attribute :initialize_hooks, default: []
  class_attribute :setup_hooks, default: []

  # Register hook methods for initialization phase
  def self.register_initialize_hook(method_name)
    self.initialize_hooks += [method_name]
  end

  # Register hook methods for setup phase
  def self.register_setup_hook(method_name)
    self.setup_hooks += [method_name]
  end

  # Enhanced initialize that calls all registered initialization hooks
  def initialize(*args, **kws, &block)
    super
    
    # Call all registered initialization hooks
    self.class.initialize_hooks.each do |hook_method|
      self.send(hook_method) if self.respond_to?(hook_method)
    end
  end

  # Add a setup_component method that's called by before_render
  def setup_component
    # Call all registered setup hooks
    self.class.setup_hooks.each do |hook_method|
      self.send(hook_method) if self.respond_to?(hook_method)
    end
  end

  # Enhance before_render to call setup_component
  def before_render
    setup_component
  end
end
```

### 2. Create Tests for BaseComponent Hook System

**Purpose**: Ensure the hook registration and execution system works correctly.

**File to Create**: `spec/lib/loco_motion/base_component_hooks_spec.rb`

**Test Cases**:
- Test that hooks are properly registered at the class level
- Test that initialize hooks are called during component initialization
- Test that setup hooks are called during setup_component
- Test inheritance of hooks from parent classes
- Test that hooks are not duplicated

```ruby
RSpec.describe LocoMotion::BaseComponent do
  describe "hook system" do
    let(:test_component_class) do
      Class.new(LocoMotion::BaseComponent) do
        def self.name
          "TestComponent"
        end
        
        register_initialize_hook :init_hook
        register_setup_hook :setup_hook
        
        attr_reader :init_called, :setup_called
        
        def init_hook
          @init_called = true
        end
        
        def setup_hook
          @setup_called = true
        end
      end
    end
    
    let(:component) { test_component_class.new }
    
    it "calls initialize hooks during initialization" do
      expect(component.init_called).to be true
    end
    
    it "calls setup hooks during before_render" do
      component.before_render
      expect(component.setup_called).to be true
    end
    
    # More tests for inheritance, etc.
  end
end
```

### 3. Refactor TippableComponent Concern

**Purpose**: Update the TippableComponent concern to register hooks with BaseComponent.

**File to Edit**: `lib/loco_motion/concerns/tippable_component.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/concerns/tippable_component.rb`

**Changes**:
```ruby
module LocoMotion::Concerns::TippableComponent
  extend ActiveSupport::Concern

  included do
    # Register our hooks when this concern is included
    register_initialize_hook :initialize_tippable_component
    register_setup_hook :setup_tippable_component
  end

  # Initialize tooltip-related options
  def initialize_tippable_component
    @tip = config_option(:tip)
  end

  # Configure tooltip functionality
  def setup_tippable_component
    if @tip
      add_css(:component, "tooltip")
      add_html(:component, { data: { tip: @tip } })
    end
  end
end
```

### 4. Refactor LinkableComponent Concern

**Purpose**: Update the LinkableComponent concern to register hooks with BaseComponent.

**File to Edit**: `lib/loco_motion/concerns/linkable_component.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/concerns/linkable_component.rb`

**Changes**:
```ruby
module LocoMotion::Concerns::LinkableComponent
  extend ActiveSupport::Concern

  included do
    # Register our hooks when this concern is included
    register_initialize_hook :initialize_linkable_component
    register_setup_hook :setup_linkable_component
  end

  # Initialize link-related options
  def initialize_linkable_component
    @href = config_option(:href)
    @target = config_option(:target)
  end

  # Configure link functionality
  def setup_linkable_component
    if @href
      set_tag_name(:component, :a)
      add_html(:component, { href: @href, target: @target })
    end
  end
end
```

### 5. Refactor IconableComponent Concern

**Purpose**: Update the IconableComponent concern to register hooks with BaseComponent.

**File to Edit**: `lib/loco_motion/concerns/iconable_component.rb`

**Reference Files**:
- Current implementation in `lib/loco_motion/concerns/iconable_component.rb`

**Changes**:
```ruby
module LocoMotion::Concerns::IconableComponent
  extend ActiveSupport::Concern

  included do
    # Register our hooks when this concern is included
    register_initialize_hook :initialize_iconable_component
    register_setup_hook :setup_iconable_component
  end

  # Initialize icon-related options
  def initialize_iconable_component
    @icon = config_option(:icon)
    @left_icon = config_option(:left_icon, @icon)
    @right_icon = config_option(:right_icon)
  end

  # Configure icon functionality
  def setup_iconable_component
    if @icon || @left_icon || @right_icon
      add_css(:component, "where:inline-flex where:items-center where:gap-2")
    end
  end
end
```

### 6. Verify and Update Component initialize Methods

**Purpose**: Ensure all component initialize methods call super.

**Action**: Audit all component classes to verify they call super in their initialize method.

**Approach**:
1. Create a script to scan all component files for initialize methods
2. Verify each one calls super at the beginning
3. Fix any components that don't call super

```ruby
# Example script to find components missing super in initialize
require 'pathname'

components_dir = Pathname.new("app/components")
component_files = Dir.glob(components_dir.join("**/*.rb"))

problems = []

component_files.each do |file|
  content = File.read(file)
  if content.match?(/\s+def\s+initialize/) && !content.match?(/\s+def\s+initialize.*\n\s+super/m)
    problems << file
  end
end

puts "Components potentially missing super in initialize:"
puts problems
```

### 7. Update Components with before_render Methods

**Purpose**: Ensure all components with before_render methods call super.

**Action**: Audit all component classes to verify they call super in their before_render method.

**Approach**:
1. Create a script to scan all component files for before_render methods
2. Verify each one calls super
3. Update components that don't call super

```ruby
# Example script to find components missing super in before_render
require 'pathname'

components_dir = Pathname.new("app/components")
component_files = Dir.glob(components_dir.join("**/*.rb"))

problems = []

component_files.each do |file|
  content = File.read(file)
  if content.match?(/\s+def\s+before_render/) && !content.match?(/\s+def\s+before_render.*\n\s+super/m)
    problems << file
  end
end

puts "Components potentially missing super in before_render:"
puts problems
```

### 8. Update Component Classes

**Purpose**: Remove explicit hook calls from components now that they're automatically handled.

**Example Component to Edit**: `app/components/daisy/data_display/badge_component.rb`

**Reference Files**:
- Current implementation in various component files

**Before**:
```ruby
def initialize(*args, **kws, &block)
  super
  
  initialize_tippable_component
  initialize_linkable_component
  initialize_iconable_component
  
  # Component-specific initialization
  @color = config_option(:color, :neutral)
  @size = config_option(:size, :md)
end

def setup_component
  set_tag_name(:component, :span)
  add_css(:component, "badge")
  
  setup_tippable_component
  setup_linkable_component
  setup_iconable_component
end
```

**After**:
```ruby
def initialize(*args, **kws, &block)
  super
  
  # Only component-specific initialization remains
  @color = config_option(:color, :neutral)
  @size = config_option(:size, :md)
end

def setup_component
  super # Important: call super to invoke the hooks
  
  # Only component-specific setup remains
  set_tag_name(:component, :span)
  add_css(:component, "badge")
end

# Or if the component uses before_render instead of setup_component
def before_render
  super # Important: call super to invoke setup_component and hooks
  
  # Additional component-specific setup
end
```

### 9. Update Tests

**Purpose**: Ensure all components still behave correctly with the new hook system.

**Files to Update**: All component and concern spec files

## Migration Strategy

1. Implement the hook system in BaseComponent
2. Create tests for the hook system
3. Update each concern to register its hooks
4. Audit and fix components that don't call super in initialize or before_render
5. Update one test component and ensure its tests pass
6. Gradually update all components to remove explicit hook calls
7. Run the full test suite to verify everything works correctly
8. Update documentation to reflect the new hook system

## Benefits

1. **Reduced Boilerplate**: Components no longer need to explicitly call each 
   concern's initialization and setup methods
2. **Consistency**: All concerns will be initialized and set up in a consistent way
3. **Maintainability**: Adding new concerns doesn't require modifying component 
   initialization and setup logic
4. **Decoupling**: Concerns define their own lifecycle hooks without requiring 
   component knowledge
5. **Extensibility**: Additional hook points can be added as needed (e.g., for 
   cleanup or other lifecycle events)
6. **Safety**: By ensuring all components call super, we guarantee the hook system
   works consistently across the entire codebase

This approach aligns with Ruby on Rails' philosophy of "convention over 
configuration" and will make the codebase more maintainable as it grows.
