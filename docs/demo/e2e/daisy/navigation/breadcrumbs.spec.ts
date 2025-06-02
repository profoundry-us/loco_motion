import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Breadcrumbs nav link
  await loco.clickNavLink(page, 'Breadcrumbs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Breadcrumbs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Breadcrumbs',
    'Breadcrumbs with Icons',
    'Custom Breadcrumbs'
  ]);
});
