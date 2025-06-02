import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Navbars nav link
  await loco.clickNavLink(page, 'Navbars');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Navbars | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Navbar',
    'Advanced Navbar'
  ]);
});
