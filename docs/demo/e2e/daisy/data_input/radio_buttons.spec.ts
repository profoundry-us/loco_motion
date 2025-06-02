import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Radio Buttons nav link
  await loco.clickNavLink(page, 'Radio Buttons');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Radio Buttons | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Radio Buttons',
    'Radio Buttons with Colors',
    'Radio Button States',
    'Disabled Radio Button',
    'Custom ID',
    'Rails Form Example',
    'Using Label Component'
  ]);
});
