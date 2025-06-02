import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Code Blocks nav link
  await loco.clickNavLink(page, 'Code Blocks');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Code Blocks | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Code Block',
    'Multi-line Code Block',
    'Code Block with Language',
    'Numbered / Highlighted Lines'
  ]);
});
