import { test, expect } from '@playwright/test';

/**
 * The components overview page (Docs → Components) renders one live preview
 * card per registered component, grouped like the sidebar nav, and each card
 * links through to the component's example page.
 */
test.describe('components overview', () => {
  test('renders a live card per component and navigates on click', async ({ page }) => {
    await page.goto('/docs/components');

    // One card per registry entry — assert a floor so newly registered
    // components never break the spec (70 at the time of writing).
    const cards = page.locator('a[aria-label$=" examples"]');
    expect(await cards.count(), 'expected a card per registered component').toBeGreaterThanOrEqual(70);

    // Section and group headings mirror the sidebar nav. Scope to the
    // content frame — the sidebar renders its own "Loco" / "Daisy" headers.
    const content = page.locator('#content');
    await expect(content.getByRole('heading', { name: 'Loco' })).toBeVisible();
    await expect(content.getByRole('heading', { name: 'Daisy' })).toBeVisible();
    await expect(content.getByRole('heading', { name: 'Actions' })).toBeVisible();

    // Clicking a card opens that component's example page.
    await page.click('a[aria-label="Buttons examples"]');
    await expect(page).toHaveURL(/examples\/Daisy::Actions::ButtonComponent/);
    await expect(page.getByRole('heading', { name: 'Buttons', exact: true })).toBeVisible();
  });

  test('the home page links to the overview', async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: 'See All Components' }).click();
    await expect(page).toHaveURL(/docs\/components/);
  });

  // Regression: an actually-open modal preview once tripped DaisyUI's
  // `:root:has(.modal[open])` page scroll lock. Programmatic scrolling
  // still works under that lock, so this must use real wheel input.
  test('the page scrolls by wheel (no preview trips the scroll lock)', async ({ page }) => {
    await page.goto('/docs/components');
    await page.mouse.wheel(0, 1500);
    await expect.poll(() => page.evaluate(() => window.scrollY)).toBeGreaterThan(500);
  });
});
