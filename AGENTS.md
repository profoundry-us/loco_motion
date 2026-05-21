## Browser Automation

When working with web automation tasks, use the chrome-devtools-mcp server for browser control. This provides direct access to Chrome DevTools Protocol for reliable page interaction.

### Tools Available

- `mcp1_navigate_page` - Navigate to URLs, go back/forward, or reload
- `mcp1_take_snapshot` - Get an accessibility tree snapshot of the page (preferred over screenshots)
- `mcp1_click` - Click on elements by uid
- `mcp1_fill` - Fill in input fields
- `mcp1_fill_form` - Fill multiple form elements at once (preferred over multiple fill calls)
- `mcp1_press_key` - Press keyboard shortcuts
- `mcp1_evaluate_script` - Run JavaScript in the page context
- `mcp1_take_screenshot` - Take screenshots (use only for visual verification, not for interaction)
- `mcp1_wait_for` - Wait for text to appear on the page

### Workflow

When automating browser interactions:

1. **Navigate to the page** using `mcp1_navigate_page`
2. **Get an outline of the page** using `mcp1_take_snapshot` to understand the structure
3. **Identify elements** by their uid from the snapshot
4. **Interact however appropriate** using click, fill, or other interaction tools
5. **Make any changes to the code** based on observations
6. **Refresh the page** and take a new snapshot to verify changes
7. **Test that the new code actually works** by interacting with the modified elements

### Best Practices

- Always take a snapshot before interacting to understand the page structure
- Use `mcp1_take_snapshot` instead of `mcp1_take_screenshot` for element identification
- Use `mcp1_fill_form` for multiple form fields instead of individual `mcp1_fill` calls
- Verify changes by refreshing and taking a new snapshot
- Use `mcp1_wait_for` when waiting for dynamic content to load
- Use `mcp1_evaluate_script` for complex interactions that can't be done with standard tools
