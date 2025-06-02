import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Cards nav link
  await loco.clickNavLink(page, 'Cards');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Cards | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Card',
    'Card Sizes'
  ]);
});
