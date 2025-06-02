import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Masks nav link
  await loco.clickNavLink(page, 'Masks');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Masks | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Masks',
    'Masked Text'
  ]);
});
