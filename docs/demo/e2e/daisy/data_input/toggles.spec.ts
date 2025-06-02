import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Toggles nav link
  await loco.clickNavLink(page, 'Toggles');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Toggles | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Toggles',
    'Toggles with Colors',
    'Toggle Sizes',
    'Toggle States',
    'Custom ID',
    'Rails Form Example',
    'Using Label Component'
  ]);
});
