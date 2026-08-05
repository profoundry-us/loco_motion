import { test, expect } from '@playwright/test';

const PAGE = '/examples/Daisy::Actions::ThemeControllerComponent';

// Themes are stored per color scheme (issue #378): savedLightTheme /
// savedDarkTheme hold the preferred theme for each scheme, and
// savedThemeMode says how the active scheme is chosen ("light" / "dark" pin
// that scheme; "system" follows the OS). The legacy single savedTheme key is
// migrated on connect.
const themeStorage = (page) =>
  page.evaluate(() => ({
    mode: localStorage.getItem('savedThemeMode'),
    light: localStorage.getItem('savedLightTheme'),
    dark: localStorage.getItem('savedDarkTheme'),
    legacy: localStorage.getItem('savedTheme'),
  }));

const clearThemeStorage = (page) =>
  page.evaluate(() => {
    ['savedTheme', 'savedThemeMode', 'savedLightTheme', 'savedDarkTheme']
      .forEach((key) => localStorage.removeItem(key));
  });

test('build_switcher_dropdown switches the theme and marks the active row', async ({ page }) => {
  await page.goto(PAGE);
  await clearThemeStorage(page);

  // The first builder switcher's radios are named "docs-switcher". Open it,
  // then pick "synthwave" (the row's link fires loco-theme#setTheme).
  const switcher = page.locator('.dropdown', { has: page.locator('input[name="docs-switcher"]') });
  await switcher.getByRole('button').first().click();
  await switcher.locator('a:has(input[value="synthwave"])').click();

  // The theme is applied + persisted into the slot matching its own
  // color-scheme (synthwave declares dark), the mode is pinned, the active
  // scheme is stamped, and the active row's radio is checked.
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'synthwave');
  await expect(page.locator('html')).toHaveAttribute('data-color-scheme', 'dark');
  expect(await themeStorage(page)).toEqual({ mode: 'dark', light: null, dark: 'synthwave', legacy: null });
  await expect(page.locator('input[name="docs-switcher"][value="synthwave"]')).toBeChecked();
});

test('clear theme removes theme attributes and storage', async ({ page }) => {
  await page.goto('/');

  // Set a dark theme
  await page.evaluate(() => {
    localStorage.setItem('savedThemeMode', 'dark');
    localStorage.setItem('savedDarkTheme', 'dark');
    document.documentElement.setAttribute('data-theme', 'dark');
    document.documentElement.setAttribute('data-color-scheme', 'dark');
  });

  // Verify the theme is set
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');

  // Open the theme dropdown
  await page.locator('[data-tip="Themes"]').click();

  // Click the clear theme button in the header
  await page.locator('[data-action*="clearTheme"]').click();

  // Verify the attributes and every storage key are removed without refresh
  await expect(page.locator('html')).not.toHaveAttribute('data-theme');
  await expect(page.locator('html')).not.toHaveAttribute('data-color-scheme');
  expect(await themeStorage(page)).toEqual({ mode: null, light: null, dark: null, legacy: null });
});

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
  await clearThemeStorage(page);

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

  // ...persist (into the light-scheme slot — both themes are light) without
  // any explicit setTheme wiring on the radio...
  await expect.poll(() => themeStorage(page)).toEqual({ mode: 'light', light: 'light', dark: null, legacy: null });

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

test('setInput reflects the applied data-theme when nothing is saved', async ({ page }) => {
  await page.goto(PAGE);

  // Simulate a first visit: a theme is applied to the document (e.g. a
  // server-rendered data-theme) but the user has not saved a choice yet.
  await page.evaluate(() => {
    ['savedTheme', 'savedThemeMode', 'savedLightTheme', 'savedDarkTheme']
      .forEach((key) => localStorage.removeItem(key));
    document.documentElement.setAttribute('data-theme', 'retro');
    // Nudge every loco-theme controller to re-sync its inputs (calls setInput).
    window.dispatchEvent(new CustomEvent('localstorage-update', { detail: { key: 'savedTheme', newValue: null } }));
  });

  // The radio for the applied theme is now checked even though nothing is saved
  // — before the fallback, getCurrentTheme() returned null and no row was marked.
  await expect(page.locator('input.theme-controller[value="retro"]').first()).toBeChecked();
});

test('legacy savedTheme is migrated to the per-scheme model on load', async ({ page }) => {
  // A returning user with the old single-key storage.
  await page.addInitScript(() => localStorage.setItem('savedTheme', 'synthwave'));
  await page.goto(PAGE);

  // The preload script honors the legacy key immediately, and the controller
  // migrates it: synthwave declares color-scheme dark, so it becomes the
  // dark-scheme preference with the mode pinned to dark.
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'synthwave');
  await expect(page.locator('html')).toHaveAttribute('data-color-scheme', 'dark');
  await expect.poll(() => themeStorage(page)).toEqual({ mode: 'dark', light: null, dark: 'synthwave', legacy: null });
});

test('system mode follows the OS scheme live, swapping between saved themes', async ({ page }) => {
  await page.emulateMedia({ colorScheme: 'light' });
  await page.addInitScript(() => {
    localStorage.setItem('savedThemeMode', 'system');
    localStorage.setItem('savedLightTheme', 'cupcake');
    localStorage.setItem('savedDarkTheme', 'night');
  });
  await page.goto(PAGE);

  // OS light: the preferred light theme applies (via the preload script).
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'cupcake');
  await expect(page.locator('html')).toHaveAttribute('data-color-scheme', 'light');

  // Flip the OS to dark: the controller's matchMedia listener swaps to the
  // preferred dark theme live, with no reload.
  await page.emulateMedia({ colorScheme: 'dark' });
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'night');
  await expect(page.locator('html')).toHaveAttribute('data-color-scheme', 'dark');
});
