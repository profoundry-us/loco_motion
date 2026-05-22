import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Hover Galleries nav link
  await loco.clickNavLink(page, 'Hover Galleries');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Hover Galleries | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Hover Gallery',
    'Hover Gallery in a Card',
    'Hover Gallery with Shorthand'
  ]);
});
