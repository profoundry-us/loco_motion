import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Lists nav link
  await loco.clickNavLink(page, 'Lists');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Lists | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic List',
    'List with Header',
    'Styled List'
  ]);
});
