import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Alerts nav link
  await loco.clickNavLink(page, 'Alerts');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Alerts | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Alerts',
    'Alerts Without Icons',
    'Custom Icon Alerts',
    'Soft Alerts',
    'Outline Alerts',
    'Dash Alerts'
  ]);
});
