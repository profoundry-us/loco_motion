import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Links nav link
  await loco.clickNavLink(page, 'Links');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Links | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Links'
  ]);
});
