import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Swaps nav link
  await loco.clickNavLink(page, 'Swaps');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Swaps | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Simple Emojis',
    'Hero Icons',
    'Custom HTML'
  ]);
});
