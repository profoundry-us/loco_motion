import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Indicators nav link
  await loco.clickNavLink(page, 'Indicators');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Indicators | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Indicator',
    'Different Positions'
  ]);
});
