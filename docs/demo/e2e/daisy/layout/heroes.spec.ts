import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Heroes nav link
  await loco.clickNavLink(page, 'Heroes');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Heroes | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Hero',
    'Heroes with Images',
    'Hero with Overlay'
  ]);
});
