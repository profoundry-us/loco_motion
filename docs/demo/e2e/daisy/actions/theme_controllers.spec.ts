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

const PAGE = '/examples/Daisy::Actions::ThemeControllerComponent';

// Fingerprint of the active theme: DaisyUI assigns each theme a distinct
// --color-primary on :root, so this tells us which theme is *visually* applied.
const appliedPrimary = (page) =>
  page.evaluate(() =>
    getComputedStyle(document.documentElement).getPropertyValue('--color-primary').trim()
  );

// Values of every currently-checked theme-controller input, across all groups.
const checkedThemeValues = (page) =>
  page.evaluate(() =>
    Array.from(document.querySelectorAll('input.theme-controller:checked')).map((i: any) => i.value)
  );

test('radio theme selection syncs everywhere and persists, even after another switcher was used', async ({ page }) => {
  await page.goto(PAGE);
  await page.evaluate(() => localStorage.removeItem('savedTheme'));

  // Capture the "light" theme fingerprint by selecting it in the radio demo.
  const lightRadio = page.locator('input[name="docs-radio-theme"][value="light"]');
  await lightRadio.check({ force: true });
  const lightPrimary = await appliedPrimary(page);

  // Select "cyberpunk" via the header "Themes" dropdown (a *different* switcher).
  // This is the exact scenario from the bug report.
  await page.locator('[data-tip="Themes"]').click();
  await page.locator('[data-action*="setTheme"]:has(input[name="docs-theme"][value="cyberpunk"])').click();
  await expect.poll(() => appliedPrimary(page)).not.toBe(lightPrimary); // cyberpunk is now applied

  // Re-select "light" in the radio demo. "light" is EARLIER than "cyberpunk" in
  // the theme list, so before the fix the stale cyberpunk inputs in the other
  // groups override it and nothing changes.
  await lightRadio.check({ force: true });

  // The radio selection must actually take effect on the page...
  await expect.poll(() => appliedPrimary(page)).toBe(lightPrimary);

  // ...persist to localStorage without any explicit setTheme wiring on the radio...
  expect(await page.evaluate(() => localStorage.getItem('savedTheme'))).toBe('light');

  // ...and sync every other switcher so no stale checked input remains.
  expect([...new Set(await checkedThemeValues(page))].sort()).toEqual(['light']);
});

test('theme-controller inputs have unique ids', async ({ page }) => {
  await page.goto(PAGE);

  const duplicateIds = await page.evaluate(() => {
    const counts: Record<string, number> = {};
    document.querySelectorAll('input.theme-controller').forEach((i: any) => {
      counts[i.id] = (counts[i.id] || 0) + 1;
    });
    return Object.entries(counts).filter(([, n]) => n > 1).map(([id, n]) => `${id} (x${n})`);
  });

  expect(duplicateIds, 'each theme-controller input should have a unique id').toEqual([]);
});
