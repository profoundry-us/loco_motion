import { test, expect } from '@playwright/test';

// Href-less link-mode tabs render as <button> elements (issue #380) so
// keyboard users can reach and activate them, and the shipped loco-tabs
// controller (issue #382) implements the ARIA tabs pattern with manual
// activation on top: a roving tabindex keeps the tablist a single Tab stop,
// Left/Right arrows move focus to browse without selecting, and Enter or
// Space activates the focused tab, keeping aria-selected in sync — DaisyUI
// treats aria-selected="true" as the active state, so a stale value leaves
// two panels open at once. The demo's Preview/Code tabs get this wiring
// automatically from the TabsComponent.
test('example tabs are keyboard-operable with manual activation', async ({ page }) => {
  await page.goto('/examples/Daisy::Actions::ButtonComponent');

  const example = page.locator("[data-controller~='doc-example']").first();
  const previewTab = example.getByRole('tab', { name: 'Preview' });
  const codeTab = example.getByRole('tab', { name: 'Code' });
  const previewPanel = example.locator("[data-doc-example-target='preview']");

  // The tabs are real <button> elements, so they can take keyboard focus.
  await previewTab.focus();
  await expect(previewTab).toBeFocused();
  await expect(previewPanel).toBeVisible();

  // ArrowRight only browses: focus moves to the Code tab, but nothing is
  // selected yet — the preview stays visible.
  await page.keyboard.press('ArrowRight');
  await expect(codeTab).toBeFocused();
  await expect(codeTab).not.toHaveClass(/(^|\s)tab-active(\s|$)/);
  await expect(codeTab).toHaveAttribute('aria-selected', 'false');
  await expect(previewPanel).toBeVisible();

  // The roving tabindex follows the FOCUSED tab (APG manual activation), so
  // the tablist stays a single Tab stop at the browsing position.
  await expect(codeTab).toHaveAttribute('tabindex', '0');
  await expect(previewTab).toHaveAttribute('tabindex', '-1');

  // Enter activates the focused tab and the panel actually swaps.
  await page.keyboard.press('Enter');
  await expect(codeTab).toHaveClass(/(^|\s)tab-active(\s|$)/);
  await expect(codeTab).toHaveAttribute('aria-selected', 'true');
  await expect(previewTab).toHaveAttribute('aria-selected', 'false');
  await expect(previewPanel).not.toBeVisible();

  // Browse back and activate with Space — buttons treat both keys as click.
  await page.keyboard.press('ArrowLeft');
  await expect(previewTab).toBeFocused();
  await expect(previewPanel).not.toBeVisible();

  await page.keyboard.press('Space');
  await expect(previewPanel).toBeVisible();
});

// The Turbo Frame Tabs example is the guard case for the switchable
// heuristic: its tabs have BOTH an href and custom content, and the href
// must win — Turbo owns the switching (a click navigates and re-renders
// the frame server-side), so loco-tabs wiring on these tabs would fight
// Turbo for control of the active state.
test('turbo frame tabs stay unwired and swap via frame navigation', async ({ page }) => {
  await page.goto('/examples/Daisy::Navigation::TabsComponent');

  const frame = page.locator('turbo-frame#tabs--turbo-tabs-example');
  const tab3 = frame.getByRole('tab', { name: '3 Bars' });
  const tab2 = frame.getByRole('tab', { name: '2 Bars' });

  // The tabs render as real links (they navigate) with NO loco-tabs wiring.
  await expect(frame.locator("a[role='tab']")).toHaveCount(3);
  await expect(frame.locator('[data-loco-tabs-target]')).toHaveCount(0);
  await expect(frame.locator("[data-action*='loco-tabs']")).toHaveCount(0);

  // Tab 3 is checked by default and shows its content.
  await expect(tab3).toHaveAttribute('aria-selected', 'true');
  await expect(frame.getByText('3 bars content...', { exact: true })).toBeVisible();

  // Clicking another tab swaps the frame server-side: new content, new
  // checked tab — all driven by Turbo, not loco-tabs.
  await tab2.click();
  await expect(frame.getByText('2 bars content...', { exact: true })).toBeVisible();
  await expect(tab2).toHaveAttribute('aria-selected', 'true');
  await expect(tab3).toHaveAttribute('aria-selected', 'false');

  // The re-rendered frame still has unwired link tabs.
  await expect(frame.locator('[data-loco-tabs-target]')).toHaveCount(0);
});

// The Switchable Tabs example on the Tabs page is auto-wired by the
// TabsComponent itself (content + no href → loco-tabs). It also nests
// inside the doc_example Preview/Code tablist, proving Stimulus scopes the
// two loco-tabs instances independently.
test('switchable tabs example: click selects, Home/End browse', async ({ page }) => {
  await page.goto('/examples/Daisy::Navigation::TabsComponent');

  const morning = page.getByRole('tab', { name: 'Morning' });
  const evening = page.getByRole('tab', { name: 'Evening' });

  await expect(page.getByText('Start the day with a strong cup of coffee.', { exact: true })).toBeVisible();

  // Click switches panels...
  await page.getByRole('tab', { name: 'Afternoon' }).click();
  await expect(page.getByText('A brisk walk beats the post-lunch slump.', { exact: true })).toBeVisible();
  await expect(page.getByText('Start the day with a strong cup of coffee.', { exact: true })).not.toBeVisible();

  // ...End browses to the last tab without selecting it...
  await page.keyboard.press('End');
  await expect(evening).toBeFocused();
  await expect(page.getByText('A brisk walk beats the post-lunch slump.', { exact: true })).toBeVisible();

  // ...Enter selects it...
  await page.keyboard.press('Enter');
  await expect(page.getByText('Wind down with a good book.', { exact: true })).toBeVisible();

  // ...and Home + Enter returns to the first.
  await page.keyboard.press('Home');
  await expect(morning).toBeFocused();
  await page.keyboard.press('Enter');
  await expect(page.getByText('Start the day with a strong cup of coffee.', { exact: true })).toBeVisible();
});
