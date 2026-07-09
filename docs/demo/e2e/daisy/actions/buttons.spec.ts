import { test, expect } from '@playwright/test';

test('ads are shown on non-hidden pages', async ({ page }) => {
  // The home page marks its content as ads-hidden (and renders without the
  // sidenav), so leave it through the hero CTA — a `_top` breakout that
  // re-renders the full layout on an ads-visible page.
  await page.goto('/');

  const adsTarget = page.locator('[data-ads-target="ads"]');
  await expect(adsTarget).not.toHaveClass(/lg:block!/);

  await page.getByRole('link', { name: '😃 Get Started' }).click();
  await page.waitForURL('**/docs/install');

  // Verify the ads target has the lg:block! class (ads should be visible)
  await expect(adsTarget).toHaveClass(/lg:block!/);

  // Verify the content target has the lg:pr-64 class
  const contentTarget = page.locator('[data-ads-target="content"]');
  await expect(contentTarget).toHaveClass(/lg:pr-64/);
});
