import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Text Inputs nav link
  await loco.clickNavLink(page, 'Text Inputs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Text Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Text Input',
    'Floating Label Inputs',
    'Different Input Types',
    'Text Input Sizes',
    'Text Input with Different Colors',
    'Ghost Style Text Input',
    'Disabled Text Input',
    'Required Text Input',
    'Text Input with Icons',
    'Rails Form Example'
  ]);
});
