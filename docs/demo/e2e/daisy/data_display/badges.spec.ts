import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Badges nav link
  await loco.clickNavLink(page, 'Badges');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Badges | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Simple Badges',
    'Badge Sizes'
  ]);
});
