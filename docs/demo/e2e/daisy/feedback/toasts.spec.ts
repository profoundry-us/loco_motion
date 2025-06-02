import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Toasts nav link
  await loco.clickNavLink(page, 'Toasts');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Toasts | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Toasts'
  ]);
});
