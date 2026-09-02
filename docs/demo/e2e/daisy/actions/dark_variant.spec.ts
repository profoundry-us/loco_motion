import { test, expect } from '@playwright/test';

// Tests for the `dark:` custom variant shipped in loco.css (issue #293).
//
// The variant should follow the app's *actual* theme — `data-theme` on the
// root element — with the OS `prefers-color-scheme` media query acting only
// as the no-choice-saved fallback, and a checked `.theme-controller` input
// still honored for pure-CSS/no-JS theme switching.
//
// Probe: an injected element with `dark:fill-base-100` (compiled into the
// demo stylesheet via the navbar example). When the variant does not match,
// the element keeps the default SVG fill of black; when it matches, fill
// resolves to the active theme's base-100 color, which is never pure black.
const darkApplies = (page) =>
  page.evaluate(() => {
    let el = document.getElementById('dark-variant-probe');
    if (!el) {
      el = document.createElement('div');
      el.id = 'dark-variant-probe';
      el.className = 'dark:fill-base-100';
      document.body.appendChild(el);
    }
    return getComputedStyle(el).fill !== 'rgb(0, 0, 0)';
  });

// Clear every theme signal: saved choice, root attribute, and any checked
// theme-controller inputs rendered by the header's Themes dropdown.
const resetTheme = (page) =>
  page.evaluate(() => {
    ['savedTheme', 'savedThemeMode', 'savedLightTheme', 'savedDarkTheme']
      .forEach((key) => localStorage.removeItem(key));
    document.documentElement.removeAttribute('data-theme');
    document.documentElement.removeAttribute('data-color-scheme');
    document
      .querySelectorAll('input.theme-controller:checked')
      .forEach((input: any) => (input.checked = false));
  });

test('dark: follows programmatic data-theme switching, ignoring the OS scheme', async ({ page }) => {
  // OS says light, and the app programmatically switches to dark with no
  // theme-controller inputs involved (the scenario from the bug report).
  await page.emulateMedia({ colorScheme: 'light' });
  await page.goto('/');
  await resetTheme(page);

  expect(await darkApplies(page)).toBe(false);

  await page.evaluate(() => document.documentElement.setAttribute('data-theme', 'dark'));
  expect(await darkApplies(page)).toBe(true);
});

test('dark: uses the OS preference as fallback, suppressed by any explicit theme choice', async ({ page }) => {
  await page.emulateMedia({ colorScheme: 'dark' });
  await page.goto('/');
  await resetTheme(page);

  // No app-level choice: the OS dark preference applies.
  expect(await darkApplies(page)).toBe(true);

  // An explicit light theme must override the OS preference...
  await page.evaluate(() => document.documentElement.setAttribute('data-theme', 'light'));
  expect(await darkApplies(page)).toBe(false);

  // ...and so must any other non-dark theme (not just "light").
  await page.evaluate(() => document.documentElement.setAttribute('data-theme', 'retro'));
  expect(await darkApplies(page)).toBe(false);

  // Explicitly choosing dark still applies, of course.
  await page.evaluate(() => document.documentElement.setAttribute('data-theme', 'dark'));
  expect(await darkApplies(page)).toBe(true);
});

test('dark: follows the stamped data-color-scheme, regardless of theme name', async ({ page }) => {
  // The scheme stamp is how ANY dark theme (night, synthwave, custom...)
  // enables dark: utilities without hardcoding theme names (issue #378).
  await page.emulateMedia({ colorScheme: 'light' });
  await page.goto('/');
  await resetTheme(page);

  expect(await darkApplies(page)).toBe(false);

  await page.evaluate(() => document.documentElement.setAttribute('data-color-scheme', 'dark'));
  expect(await darkApplies(page)).toBe(true);

  // A stamped light scheme also suppresses the OS dark fallback.
  await page.emulateMedia({ colorScheme: 'dark' });
  await page.evaluate(() => document.documentElement.setAttribute('data-color-scheme', 'light'));
  expect(await darkApplies(page)).toBe(false);
});

test('picking a dark theme by any name enables dark: utilities', async ({ page }) => {
  // End-to-end: the ThemeController stamps the scheme from the theme's own
  // color-scheme declaration, so "synthwave" lights up dark: styles even
  // though the variant never mentions it.
  await page.emulateMedia({ colorScheme: 'light' });
  await page.goto('/examples/Daisy::Actions::ThemeControllerComponent');
  await resetTheme(page);

  expect(await darkApplies(page)).toBe(false);

  const switcher = page.locator('.dropdown', { has: page.locator('input[name="docs-switcher"]') });
  await switcher.getByRole('button').first().click();
  await switcher.locator('a:has(input[value="synthwave"])').click();

  await expect(page.locator('html')).toHaveAttribute('data-color-scheme', 'dark');
  expect(await darkApplies(page)).toBe(true);
});

test('dark: still honors a checked .theme-controller input (pure-CSS switching)', async ({ page }) => {
  // No data-theme and OS light — only a checked DaisyUI theme-controller
  // input signals dark, as in a no-JS/pure-CSS setup.
  await page.emulateMedia({ colorScheme: 'light' });
  await page.goto('/');
  await resetTheme(page);

  expect(await darkApplies(page)).toBe(false);

  await page.evaluate(() => {
    const input = document.createElement('input');
    input.type = 'checkbox';
    input.className = 'theme-controller';
    input.value = 'dark';
    input.checked = true;
    document.body.appendChild(input);
  });
  expect(await darkApplies(page)).toBe(true);
});
