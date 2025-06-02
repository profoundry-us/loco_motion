import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Buttons nav link
  await loco.clickNavLink(page, 'Buttons');

  // Expect the title and a few headings
  await loco.expectPageTitle(page, /Buttons | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Buttons',
    'Icon Buttons',
    'Multiple Sizes'
  ]);
});
