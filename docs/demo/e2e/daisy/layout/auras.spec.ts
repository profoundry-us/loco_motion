import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Auras nav link
  await loco.clickNavLink(page, 'Auras');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Auras | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Aura',
    'Aura Variants',
    'Aura Sizes',
    'Aura Around a Button',
    'Custom Colors',
    'Clickable Aura'
  ]);
});
