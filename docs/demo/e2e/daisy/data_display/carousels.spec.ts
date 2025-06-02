import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Carousels nav link
  await loco.clickNavLink(page, 'Carousels');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Carousels | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Carousel',
    'Card Carousel'
  ]);
});
