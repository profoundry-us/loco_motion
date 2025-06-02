import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Skeletons nav link
  await loco.clickNavLink(page, 'Skeletons');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Skeletons | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Skeletons',
    'Component Skeletons'
  ]);
});
