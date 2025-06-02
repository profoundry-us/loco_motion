import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Diffs nav link
  await loco.clickNavLink(page, 'Diffs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Diffs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Text / HTML Diff',
    'Image Diff'
  ]);
});
