import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Figures nav link
  await loco.clickNavLink(page, 'Figures');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Figures | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Figure',
    'Figure with Caption',
    'Custom Content'
  ]);
});
