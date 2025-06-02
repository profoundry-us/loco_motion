import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the File Inputs nav link
  await loco.clickNavLink(page, 'File Inputs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /File Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic File Input',
    'File Input with Accept Attribute',
    'Multiple File Selection',
    'File Input with Different Colors',
    'Ghost Style File Input',
    'Disabled File Input',
    'Required File Input',
    'Rails Form Example'
  ]);
});
