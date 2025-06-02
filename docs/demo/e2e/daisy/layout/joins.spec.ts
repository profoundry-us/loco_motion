import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Joins nav link
  await loco.clickNavLink(page, 'Joins');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Joins | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Button Joins',
    'Vertical Joins'
  ]);
});
