import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Tooltips nav link
  await loco.clickNavLink(page, 'Tooltips');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Tooltips | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Component Tooltips',
    'Wrapper Tooltips'
  ]);
});
