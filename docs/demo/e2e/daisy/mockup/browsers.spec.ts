import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Browsers nav link
  await loco.clickNavLink(page, 'Browsers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Browsers | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Browser',
    'Styled Browser'
  ]);
});
