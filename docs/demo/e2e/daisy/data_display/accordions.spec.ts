import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Accordions nav link
  await loco.clickNavLink(page, 'Accordions');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Accordions | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Accordion',
    'Separated Accordion',
    'Form Accordion'
  ]);
});
