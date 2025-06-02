import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Stats nav link
  await loco.clickNavLink(page, 'Stats');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Stats | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Stats'
  ]);
});
