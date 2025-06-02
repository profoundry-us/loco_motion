import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Menus nav link
  await loco.clickNavLink(page, 'Menus');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Menus | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Menu',
    'Horizontal Menu',
    'Nested Menus'
  ]);
});
