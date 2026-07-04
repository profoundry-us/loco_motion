import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('ads are shown on non-hidden pages', async ({ page }) => {
  await page.goto('/');

  // Click the Buttons nav link (this page should NOT have hidden target)
  await loco.clickNavLink(page, 'Buttons');

  // Verify the ads target has the lg:block! class (ads should be visible)
  const adsTarget = page.locator('[data-ads-target="ads"]');
  await expect(adsTarget).toHaveClass(/lg:block!/);

  // Verify the content target has the lg:pr-64 class
  const contentTarget = page.locator('[data-ads-target="content"]');
  await expect(contentTarget).toHaveClass(/lg:pr-64/);
});
