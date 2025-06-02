import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Loaders nav link
  await loco.clickNavLink(page, 'Loaders');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Loaders | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Loaders'
  ]);
});
