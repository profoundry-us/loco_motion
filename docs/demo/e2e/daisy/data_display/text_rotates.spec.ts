import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Text Rotates nav link
  await loco.clickNavLink(page, 'Text Rotates');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Text Rotates | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Text Rotate',
    'Text Rotate with texts Shorthand',
    'Text Rotate with Centered Items',
    'Text Rotate with Custom Duration',
    'Text Rotate Inline in a Sentence',
    'With Different Font Sizes',
    'With Custom Line Height'
  ]);
});
