import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Countdowns nav link
  await loco.clickNavLink(page, 'Countdowns');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Countdowns | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Countdown',
    'Longer Countdown'
  ]);
});
