import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Dropdowns link
  await loco.clickNavLink(page, 'Dropdowns');

  // Expect the title and selected headings
  await loco.expectPageTitle(page, /Dropdowns | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Dropdown',
    'Custom Button',
    'Fully Custom Dropdown'
  ]);
});
