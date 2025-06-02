import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Chat Bubbles nav link
  await loco.clickNavLink(page, 'Chat Bubbles');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Chat Bubbles | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Advanced Chat'
  ]);
});
