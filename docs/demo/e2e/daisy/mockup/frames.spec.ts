import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Frames nav link
  await loco.clickNavLink(page, 'Frames');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Frames | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Frame',
    'Styled Frame'
  ]);
});
