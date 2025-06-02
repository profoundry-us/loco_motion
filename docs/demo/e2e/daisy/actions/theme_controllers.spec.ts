import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Theme Controllers nav link
  await loco.clickNavLink(page, 'Theme Controllers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Theme Controller | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Theme Preview Icons',
    'Theme Radio Inputs',
    'Custom Switcher'
  ]);
});
