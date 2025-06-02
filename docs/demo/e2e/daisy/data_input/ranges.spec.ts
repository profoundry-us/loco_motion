import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Ranges nav link
  await loco.clickNavLink(page, 'Ranges');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Range Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Range',
    'Range with Colors',
    'Range with Steps',
    'Range States',
    'Rails Form Example'
  ]);
});
