import { test } from '@playwright/test';
import { loco } from '../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Hero Icons link.
  await loco.clickNavLink(page, 'Icons');

  // Expect the title and a few headings
  await loco.expectPageTitle(page, /Icons | LocoMotion/);
  await loco.expectPageHeadings(page, ['Basic Icons', 'Customized Icons']);
});
