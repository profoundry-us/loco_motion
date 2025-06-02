import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Collapses nav link
  await loco.clickNavLink(page, 'Collapses');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Collapses | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Collapse',
    'Arrow & Plus Collapses',
    'Advanced Collapse'
  ]);
});
