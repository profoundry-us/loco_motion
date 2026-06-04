# Enhance LLM Documentation for Better AI Assistant Integration

## Overview

This refactoring enhances the LLM documentation system to provide more structured,
comprehensive, and AI-friendly documentation. The improvements focus on adding
metadata, API signatures, usage patterns, component relationships, Rails
integration context, and categorical organization to make the documentation
more useful for LLMs like ChatGPT, Claude, and Gemini.

## External Resources

- LLM Documentation Implementation:
  `docs/demo/app/services/algolia/llm_text_export_service.rb`
- Original LLM Pipeline Plan:
  `docs/plans/2025-09-generate_llm_txt_from_algolia_pipeline.md`
- Component Registry:
  `lib/loco_motion.rb`

## Implementation Steps

### 1. Analyze Current Implementation and Data Sources

**Purpose**: Understand current data structure and identify what information is
available for the enhanced documentation.

**Files to Review**:
- `docs/demo/app/services/algolia/llm_text_export_service.rb`
- `docs/demo/app/services/algolia/llm_aggregation_service.rb`
- `lib/loco_motion.rb` (component registry)
- `lib/loco_motion/helpers.rb` (helper definitions)

**Key Concerns**:
- Current data structure provides basic component info but lacks API signatures
- Need to extract method signatures from component classes
- Component relationships need to be inferred or manually defined
- Rails integration context needs to be added systematically
- Category organization already exists in component registry

### 2. Extend Data Aggregation Service

**Purpose**: Enhance the aggregation service to collect additional metadata for
each component.

**Files to Edit**:
- `docs/demo/app/services/algolia/llm_aggregation_service.rb`

**Changes to Make**:
- Add method signature extraction using Ruby introspection
- Extract component categories from registry for organization
- Collect Rails-specific metadata (inheritance, included modules)
- Identify related components based on category and usage patterns
- Gather helper method information from component registry
- Extract component parameters and their types from initialize methods

### 3. Create Metadata Extraction Utilities

**Purpose**: Build utility methods to extract structured information from
component classes.

**Files to Create**:
- `docs/demo/app/services/algolia/component_metadata_extractor.rb`

**Functionality**:
- Extract method signatures with parameter types and defaults
- Identify component categories and groupings
- Detect common usage patterns from example code
- Find related components based on category and example co-usage
- Extract Rails integration information
- Generate API documentation in standardized format

### 4. Update LLM Text Export Service

**Purpose**: Modify the export service to include the new structured sections
and enhanced formatting.

**Files to Edit**:
- `docs/demo/app/services/algolia/llm_text_export_service.rb`

**Changes to Make**:
- Add library metadata section with framework info and statistics
- Include component API signatures with parameter documentation
- Add common usage patterns section with Rails conventions
- Include related components for each component entry
- Add Rails integration context and helper method documentation
- Create categorized component index
- Improve code block formatting by removing documentation boilerplate
- Optimize for token efficiency with clear section delimiters

### 5. Update Component Registry Metadata

**Purpose**: Enhance the component registry with relationship and pattern
information.

**Files to Edit**:
- `lib/loco_motion.rb`

**Changes to Make**:
- Add component relationship mappings where appropriate
- Include common usage pattern hints for key components
- Add Rails integration notes for complex components
- Enhance component metadata with category-specific information

### 6. Create Usage Patterns Documentation

**Purpose**: Document common patterns and conventions for LLM reference.

**Files to Create**:
- `docs/demo/data/usage_patterns.md` (Markdown file)

**Functionality**:
- Simple Markdown file with common usage patterns
- Organized by use case (forms, navigation, layout, etc.)
- Include Rails-specific conventions and best practices
- Easy for LLMs to analyze and update
- Can be directly included in LLM documentation output

**Implementation**:
- Create structured Markdown with sections for each pattern category
- Export service reads the file and includes it in the documentation
- No Ruby code needed - just maintain the Markdown file
- Can be easily updated manually or with LLM assistance

### 7. Update Spec Files

**Purpose**: Add tests for the new functionality and ensure existing tests
pass with the enhanced output.

**Files to Edit**:
- `docs/demo/spec/services/algolia/llm_text_export_service_spec.rb`
- `docs/demo/spec/services/algolia/llm_aggregation_service_spec.rb`

**Changes to Make**:
- Add tests for metadata extraction functionality
- Test new documentation sections and formatting
- Verify API signature extraction accuracy
- Test component relationship detection
- Validate usage pattern generation

### 8. Update Documentation

**Purpose**: Update developer documentation to reflect the enhanced LLM
documentation capabilities.

**Files to Edit**:
- `docs/dev_guides/ALGOLIA.md`
- `docs/demo/app/views/docs/03_llms.html.haml`

**Changes to Make**:
- Document new metadata sections and their purpose
- Update usage examples to show enhanced documentation
- Add troubleshooting guide for LLM integration
- Include examples of effective LLM prompting with new documentation

### 9. Add Rake Task Options

**Purpose**: Add command-line options for controlling the enhanced documentation
generation.

**Files to Edit**:
- `docs/demo/lib/tasks/algolia.rake`

**Changes to Make**:
- Add `--include-patterns` flag to include/exclude usage patterns
- Add `--metadata-level` option for controlling detail level
- Add `--format` option for different output formats
- Add `--categories` flag to limit output to specific categories

## Verification Steps

**Purpose**: Verify the enhanced documentation works correctly and provides
value to LLMs.

**Commands to Run**:
```bash
# Generate enhanced documentation
docker compose exec -it demo bundle exec rake algolia:llm

# Test with specific component
docker compose exec -it demo bundle exec rake algolia:llm --component Daisy::Actions::ButtonComponent

# Test patterns extraction
docker compose exec -it demo bundle exec rake algolia:llm --include-patterns

# Run specs
docker compose exec -it demo bundle exec rspec spec/services/algolia/
```

**Expected Results**:
- Generated documentation includes all new sections
- API signatures are accurate and complete
- Component relationships are logical and helpful
- Usage patterns provide clear guidance for common tasks
- Rails integration context is comprehensive
- Categorized index makes navigation easy
- All existing tests continue to pass
- New tests cover enhanced functionality
- Documentation is well-formatted and readable by both humans and LLMs

## Success Criteria

1. **Structured Metadata**: Documentation begins with comprehensive library
   metadata including framework info, component counts, and categories.

2. **API Signatures**: Each component includes complete method signatures with
   parameter types, descriptions, and default values.

3. **Usage Patterns**: Common patterns are documented with Rails conventions
   and practical examples.

4. **Component Relationships**: Related components are listed for each entry,
   helping LLMs suggest complementary components.

5. **Rails Integration**: Comprehensive Rails-specific context including
   ViewComponent integration, helper methods, and asset pipeline information.

6. **Categorical Organization**: Components are organized by category with
   dedicated index sections for easy navigation.

7. **Backward Compatibility**: Existing functionality remains intact and all
   current tests pass.

8. **Token Efficiency**: Documentation is structured to maximize information
  density while remaining readable and useful to LLMs.
