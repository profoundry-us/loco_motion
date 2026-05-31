# Fix LLM Documentation Content Issues

## Overview

During testing of the enhanced LLM documentation, several content quality issues
were identified that reduce the effectiveness of the documentation for LLM
consumption. This plan addresses critical and minor issues to improve the overall
quality and usability of the generated documentation.

**CRITICAL IMPLEMENTATION GUIDELINE**: Previous attempts to fix similar issues
have failed when using complex regular expressions. ALL solutions in this plan
must use simple, straightforward string manipulation methods. No complex regex
patterns, no sophisticated parsing attempts. Use basic string operations like
`gsub`, `split`, `include?`, `start_with?`, and simple loops.

## External Resources

- LLM Text Export Service:
  `docs/demo/app/services/algolia/llm_text_export_service.rb`
- HAML Parser Service:
  `docs/demo/app/services/algolia/haml_parser_service.rb`
- Generated Documentation:
  `docs/demo/public/llms-full-v0.5.1.txt`
- Component Examples: `app/views/examples/`

## Implementation Steps

### 1. Analyze Current Implementation

**Purpose**: Understand the root cause of content quality issues

**Files to Review**:
- `docs/demo/app/services/algolia/haml_parser_service.rb`
- `docs/demo/app/services/algolia/llm_text_export_service.rb`
- `docs/demo/public/llms-full-v0.5.1.txt`

**Key Concerns**:
- HAML parser not properly extracting clean text from complex descriptions
- Description truncation logic cutting off important information
- Documentation boilerplate remaining in code examples
- Inconsistent formatting and spacing throughout output

**IMPORTANT**: Do NOT use complex regular expressions to fix these issues.
Previous attempts with complex regex patterns have failed. Use simple,
straightforward string manipulation and parsing approaches instead.

### 2. Fix HAML Description Parsing

**Purpose**: Extract clean, readable text from complex HAML descriptions

**Files to Edit**:
- `docs/demo/app/services/algolia/haml_parser_service.rb`

**Changes to Make**:
- Improve text extraction logic to handle embedded components
- Strip HAML syntax and Ruby code from descriptions
- Clean up malformed text like "succeed "." do daisy_link(...)"
- Add proper sentence boundary detection
- Handle nested components and helper method calls

**CRITICAL**: Avoid complex regex patterns. Use simple string methods
like `gsub`, `split`, and basic pattern matching. Focus on removing
obvious HAML/Ruby artifacts rather than trying to parse perfectly.

### 3. Clean Up Code Examples

**Purpose**: Remove documentation boilerplate from code examples

**Files to Edit**:
- `docs/demo/app/services/algolia/llm_text_export_service.rb`

**Changes to Make**:
- Update `write_examples_section` method to strip `doc_example` wrappers
- Extract only the inner content of `doc_example` blocks
- Preserve the actual component usage code
- Remove documentation-specific attributes like `example_css`

**WARNING**: Do NOT attempt complex regex-based HTML/HAML parsing.
Use simple string manipulation to identify and remove `doc_example`
lines and extract the indented content within them.

### 4. Fix Description Truncation

**Purpose**: Provide complete, useful descriptions instead of truncated ones

**Files to Edit**:
- `docs/demo/app/services/algolia/llm_text_export_service.rb`

**Changes to Make**:
- Increase or remove description length limits in `truncate_description`
- Implement smart truncation at sentence boundaries
- Add logic to preserve complete thoughts
- Consider different limits for index vs full documentation

### 5. Fix Formatting and Spacing Issues

**Purpose**: Improve readability and consistency of the documentation

**Files to Edit**:
- `docs/demo/app/services/algolia/llm_text_export_service.rb`

**Changes to Make**:
- Fix extra blank line after "## Common Usage Patterns" header
- Add proper spacing between major sections
- Ensure consistent header formatting
- Standardize blank line usage throughout

### 6. Add Content Validation Tests

**Purpose**: Prevent regression of content quality issues

**Files to Create**:
- `docs/demo/spec/services/algolia/llm_content_quality_spec.rb`

**Changes to Make**:
- Add tests for description cleanliness
- Check for HAML syntax contamination
- Verify code examples don't contain boilerplate
- Test description length limits
- Validate formatting consistency

### 7. Update Documentation Generation Process

**Purpose**: Ensure clean content generation pipeline

**Files to Edit**:
- `docs/demo/lib/tasks/algolia.rake`

**Changes to Make**:
- Add content validation step to rake task
- Include warnings for potential content issues
- Add option to regenerate with specific fixes
- Improve error reporting for content problems

## Verification Steps

**Purpose**: Verify all fixes work correctly and don't introduce new issues

**Commands to Run**:
```bash
# Generate enhanced documentation
docker compose exec -it demo bundle exec rake algolia:llm

# Test specific component
docker compose exec -it demo bundle exec rake algolia:llm ARGS="-c Hero::IconComponent"

# Run content quality tests
docker compose exec -it demo bundle exec rspec spec/services/algolia/llm_content_quality_spec.rb
```

**Expected Results**:
- Hero::IconComponent description is clean and readable
- No descriptions end abruptly with "..."
- Code examples show clean component usage without boilerplate
- Formatting is consistent throughout the document
- All content quality tests pass
- File sizes remain reasonable
- Generation process is stable and reliable
