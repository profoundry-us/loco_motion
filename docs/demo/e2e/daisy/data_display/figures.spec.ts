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

  // Wait a moment for the page to load
  await page.waitForTimeout(1000);

  // Debug: Take a screenshot to see what's on the page
  await page.screenshot({ path: 'debug-figures-page.png' });

  // Debug: Check all headings on the page
  const headings = await page.locator('h2').allTextContents();
  console.log('Found headings:', headings);

  // Test default positioning (image before content)
  const basicFigure = page.locator('h2:has-text("Basic Figure") + div figure');
  const basicImage = basicFigure.locator('img');
  const basicCaption = basicFigure.locator('p:has-text("Figures are used to display images")');

  await expect(basicImage).toBeVisible();
  await expect(basicCaption).toBeVisible();

  // Test bottom positioning (content before image)
  const bottomFigure = page.locator('h2:has-text("Figure with Bottom Position") + div figure');
  const bottomImage = bottomFigure.locator('img');
  const bottomCaption = bottomFigure.locator('p:has-text("A serene forest pathway")');

  await expect(bottomImage).toBeVisible();
  await expect(bottomCaption).toBeVisible();

  // Verify that in bottom figure, caption comes before image
  const bottomFigureHTML = await bottomFigure.innerHTML();
  const captionIndex = bottomFigureHTML.indexOf('A serene forest pathway');
  const imageIndex = bottomFigureHTML.indexOf('<img');

  expect(captionIndex).toBeLessThan(imageIndex);
});
