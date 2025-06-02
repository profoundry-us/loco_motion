import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Dividers nav link
  await loco.clickNavLink(page, 'Dividers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Dividers | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Dividers',
    'Colored Dividers'
  ]);
});
