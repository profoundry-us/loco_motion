import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Cally Inputs nav link
  await loco.clickNavLink(page, 'Cally Inputs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Cally Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Usage',
    'Custom Input',
    'Rails Form Example'
  ]);
});
