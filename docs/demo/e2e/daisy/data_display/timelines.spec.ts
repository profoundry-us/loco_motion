import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Timelines nav link
  await loco.clickNavLink(page, 'Timelines');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Timelines | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Timeline',
    'Custom Timeline'
  ]);
});
