import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Theme Controllers nav link
  await loco.clickNavLink(page, 'Theme Controllers');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Theme Controller | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Theme Preview Icons',
    'Theme Radio Inputs',
    'Custom Switcher'
  ]);
});

test('clear theme removes data-theme attribute', async ({ page }) => {
  await page.goto('/');

  // Set a dark theme
  await page.evaluate(() => {
    localStorage.setItem('savedTheme', 'dark');
    document.documentElement.setAttribute('data-theme', 'dark');
  });

  // Verify the theme is set
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');

  // Open the theme dropdown
  await page.locator('[data-tip="Themes"]').click();

  // Click the clear theme button in the header
  await page.locator('[data-action*="clearTheme"]').click();

  // Verify the data-theme attribute is removed without page refresh
  await expect(page.locator('html')).not.toHaveAttribute('data-theme');
});
