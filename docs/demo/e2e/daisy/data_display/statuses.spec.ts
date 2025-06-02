import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Statuses nav link
  await loco.clickNavLink(page, 'Statuses');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Status | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Status',
    'Status Sizes',
    'Status Colors',
    'Status with Tooltip and Aria Label'
  ]);
});
