import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Selects nav link
  await loco.clickNavLink(page, 'Selects');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Select Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Select',
    'Select with Simple Options',
    'Select Sizes',
    'Select with Colors',
    'Ghost Select',
    'Disabled Select',
    'Required Select',
    'Pre-Selected Value',
    'Block Syntax for Options',
    'Rails Form Example'
  ]);
});
