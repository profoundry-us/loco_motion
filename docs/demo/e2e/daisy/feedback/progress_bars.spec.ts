import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Progress Bars nav link
  await loco.clickNavLink(page, 'Progress Bars');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Progress Bars | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Bars',
    'Indeterminate Bars'
  ]);
});
