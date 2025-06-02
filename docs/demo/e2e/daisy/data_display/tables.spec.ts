import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Tables nav link
  await loco.clickNavLink(page, 'Tables');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Tables | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Table',
    'Pinning Rows (Using Sections)'
  ]);
});
