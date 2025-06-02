import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Tabs nav link
  await loco.clickNavLink(page, 'Tabs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Tabs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Tabs',
    'Tab Sizes',
    'Radio Button Tabs with Content',
    'Turbo Frame Tabs'
  ]);
});
