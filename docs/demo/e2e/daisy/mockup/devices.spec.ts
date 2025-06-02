import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Devices nav link
  await loco.clickNavLink(page, 'Devices');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Devices | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Phone',
    'Tablet'
  ]);
});
