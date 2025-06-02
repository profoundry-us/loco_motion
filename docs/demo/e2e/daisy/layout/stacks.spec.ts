import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Stacks nav link
  await loco.clickNavLink(page, 'Stacks');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Stacks | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Stack',
    'Animated Stack',
    'Stack Positions',
    'CSS Stack'
  ]);
});
