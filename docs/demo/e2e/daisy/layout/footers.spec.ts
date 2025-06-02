import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Footers nav link
  await loco.clickNavLink(page, 'Footers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Footers | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Nav Footer (Vertical)',
    'Horizontal Footer',
    'Center-Aligned Footer'
  ]);
});
