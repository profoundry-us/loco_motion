import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Theme Previews nav link
  await loco.clickNavLink(page, 'Theme Previews');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Theme Previews | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Usage',
    'Custom Size'
  ]);
});
