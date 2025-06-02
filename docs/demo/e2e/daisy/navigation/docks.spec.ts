import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Dock nav link
  await loco.clickNavLink(page, 'Dock');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Dock | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Dock',
    'Dock with Titles',
    'Colored Dock'
  ]);
});
