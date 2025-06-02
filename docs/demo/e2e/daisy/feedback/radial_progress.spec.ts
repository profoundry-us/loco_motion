import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Radial Progress nav link
  await loco.clickNavLink(page, 'Radial Progress');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Radial Progress Bars | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Radials',
    'Fancy Radials',
    'Controlling Size & Color'
  ]);
});
