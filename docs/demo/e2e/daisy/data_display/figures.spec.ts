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

  // Test that all examples are present including the new bottom positioning example
  await expect(page.locator('h2:has-text("Basic Figure")')).toBeVisible();
  await expect(page.locator('h2:has-text("Figure with Caption")')).toBeVisible();
  await expect(page.locator('h2:has-text("Figure with Bottom Position")')).toBeVisible();
  await expect(page.locator('h2:has-text("Custom Content")')).toBeVisible();

  // Verify the bottom positioning example description is visible
  const bottomSection = page.locator('h2:has-text("Figure with Bottom Position") + div');
  await expect(bottomSection).toContainText('position: "bottom"');
  await expect(bottomSection).toContainText('display the caption above the image');
});
