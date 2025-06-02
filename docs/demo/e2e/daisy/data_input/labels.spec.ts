import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Labels nav link
  await loco.clickNavLink(page, 'Labels');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Labels | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Labels',
    'With Form Inputs',
    'LabelableComponent Functionality',
    'End Labels',
    'Floating Labels',
    'Custom Label Content',
    'Form Builder Example'
  ]);
});
