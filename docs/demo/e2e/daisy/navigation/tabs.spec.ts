import { test, expect } from '@playwright/test';

// Href-less link-mode tabs render as <button> elements (issue #380) so
// keyboard users can reach and activate them. The demo's Preview/Code tabs
// implement the full ARIA tabs pattern on top: a roving tabindex keeps the
// tablist a single Tab stop, Left/Right arrows move to and activate tabs,
// and aria-selected stays in sync — DaisyUI treats aria-selected="true" as
// the active state, so a stale value leaves two panels open at once.
test('example tabs are keyboard-operable, one panel at a time', async ({ page }) => {
  await page.goto('/examples/Daisy::Actions::ButtonComponent');

  const example = page.locator("[data-controller~='active-tab']").first();
  const previewTab = example.getByRole('tab', { name: 'Preview' });
  const codeTab = example.getByRole('tab', { name: 'Code' });
  const previewPanel = example.locator("[data-doc-example-target='preview']");

  // The tabs are real <button> elements, so they can take keyboard focus.
  await previewTab.focus();
  await expect(previewTab).toBeFocused();
  await expect(previewPanel).toBeVisible();

  // ArrowRight moves focus to and activates the Code tab...
  await page.keyboard.press('ArrowRight');
  await expect(codeTab).toBeFocused();
  await expect(codeTab).toHaveClass(/tab-active/);
  await expect(codeTab).toHaveAttribute('aria-selected', 'true');

  // ...and the preview panel actually swaps out rather than both showing.
  await expect(previewTab).toHaveAttribute('aria-selected', 'false');
  await expect(previewPanel).not.toBeVisible();

  // ArrowLeft brings the preview back.
  await page.keyboard.press('ArrowLeft');
  await expect(previewTab).toBeFocused();
  await expect(previewPanel).toBeVisible();

  // Only the active tab is a Tab stop (roving tabindex), so the tablist is
  // one stop and arrows are the way to move between tabs.
  await expect(previewTab).toHaveAttribute('tabindex', '0');
  await expect(codeTab).toHaveAttribute('tabindex', '-1');
});
