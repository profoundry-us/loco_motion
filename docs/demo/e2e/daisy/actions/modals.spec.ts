import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Modals link
  await loco.clickNavLink(page, 'Modals');

  // Expect the title and a few headings
  await loco.expectPageTitle(page, /Modals | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Simple Modal',
    'Custom Activator'
  ]);
});
