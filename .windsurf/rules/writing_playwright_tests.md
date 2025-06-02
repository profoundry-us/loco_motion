---
trigger: manual
---

When writing Playwright tests, follow these rules.

1. MUST review the associated example file (e.g. docs/demo/app/views/examples/daisy/actions/buttons.html.haml)

2. MUST follow a directory structure similar to the example files

3. MUST start with a very basic test that checks the title and at most 3 headings

4. MUST use the standard test format: `test('page loads', async ({ page }) => {...})` instead of using `test.describe()` wrappers

5. MUST use `await page.goto('/')` at the beginning of each test to ensure starting from the home page

6. MUST verify the exact navigation link text in the UI before writing tests
   - Navigation link names must match exactly as they appear in the UI (e.g., 'Statuses', not 'Status')
   - Note that some component names might be plural in the navigation while singular in the page title
   - Proper example names can be viewed as the `example` key in `lib/loco_motion/helpers.rb`

7. MUST use the correct page title format with a regular expression: `/Component Name | LocoMotion/`
   - For example: `await loco.expectPageTitle(page, /Avatars | LocoMotion/);`

8. MUST follow the `.windsurf/rules/running_playwright_tests.md` rules when running tests
