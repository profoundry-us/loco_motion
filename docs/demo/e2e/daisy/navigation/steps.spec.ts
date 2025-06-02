import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Steps nav link
  await loco.clickNavLink(page, 'Steps');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Steps | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Steps',
    'Vertical Steps',
    'Custom Content'
  ]);
});
