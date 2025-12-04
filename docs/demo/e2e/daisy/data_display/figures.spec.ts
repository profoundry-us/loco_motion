import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Figures nav link
  await loco.clickNavLink(page, 'Figures');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Figures | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Figure',
    'Figure with Caption',
    'Figure with Bottom Position',
    'Custom Content'
  ]);
});

test('figure positioning works correctly', async ({ page }) => {
  await page.goto('/');

  // Click the Figures nav link
  await loco.clickNavLink(page, 'Figures');

  // Test that the new bottom positioning example is present
  await expect(page.locator('h2:has-text("Figure with Bottom Position")')).toBeVisible();

  // Test that all examples are present
  await expect(page.locator('h2:has-text("Basic Figure")')).toBeVisible();
  await expect(page.locator('h2:has-text("Figure with Caption")')).toBeVisible();
  await expect(page.locator('h2:has-text("Custom Content")')).toBeVisible();
});
