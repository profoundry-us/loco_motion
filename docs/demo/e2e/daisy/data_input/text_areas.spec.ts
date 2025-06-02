import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Text Areas nav link
  await loco.clickNavLink(page, 'Text Areas');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Text Areas | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Text Area',
    'Text Area with Placeholder',
    'Text Area with Initial Value',
    'Custom Rows',
    'Text Area with Different Colors',
    'Borderless (Ghost) Text Area',
    'Disabled Text Area',
    'Read-only Text Area',
    'Required Text Area',
    'Rails Form Example'
  ]);
});
