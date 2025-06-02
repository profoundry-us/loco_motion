import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Pagination nav link
  await loco.clickNavLink(page, 'Pagination');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Pagination | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Pagination'
  ]);
});
