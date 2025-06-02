import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Drawers nav link
  await loco.clickNavLink(page, 'Drawers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Drawers | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Drawer',
    'Right Drawer',
    'Advanced Drawer'
  ]);
});
