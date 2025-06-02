import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Fieldsets nav link
  await loco.clickNavLink(page, 'Fieldsets');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Fieldsets | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Fieldset (No Legend)',
    'Fieldset with Legend (Argument)',
    'Fieldset with Legend (Slot)',
    'Fieldset with Various Inputs',
    'Fieldset with Custom Styling'
  ]);
});
