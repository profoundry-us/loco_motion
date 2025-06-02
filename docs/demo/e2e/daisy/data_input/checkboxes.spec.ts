import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Checkboxes nav link
  await loco.clickNavLink(page, 'Checkboxes');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Checkboxes | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Checkboxes',
    'Checkboxes with Colors',
    'Checkbox Sizes',
    'Combining Colors and Sizes',
    'Indeterminate State',
    'Disabled Checkbox',
    'Custom ID',
    'Rails Form Example',
    'Using Label Component'
  ]);
});
