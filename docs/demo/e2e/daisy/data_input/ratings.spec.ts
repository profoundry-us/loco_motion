import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Ratings nav link
  await loco.clickNavLink(page, 'Ratings');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Rating Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Rating',
    'Rating with Heart Style',
    'Rating with Colors',
    'Rating with Different Sizes',
    'Half-Star Rating',
    'Read-Only Rating',
    'Custom Content Rating',
    'Rails Form Example'
  ]);
});
