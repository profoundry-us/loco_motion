import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Avatars nav link
  await loco.clickNavLink(page, 'Avatars');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Avatars | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Avatars',
    'Linked Avatars'
  ]);
});
