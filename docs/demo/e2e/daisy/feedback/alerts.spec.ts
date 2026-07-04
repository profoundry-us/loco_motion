import { test, expect } from '@playwright/test';

// Regression for #186: the closable alert's ✕ used to be absolutely positioned
// with a zero-specificity `pr-10` reservation that lost to DaisyUI's `.alert`
// padding, so the button overlapped the message text. It is now pinned to the
// top-right corner with a reserved (plain, cascade-winning) `pr-10`, so it must
// sit at the top-right and never overlap the content.
test('closable alert close button sits top-right and does not overlap content', async ({ page }) => {
  await page.goto('/examples/Daisy::Feedback::AlertComponent');

  const closeButtons = page.locator('.alert button[data-action*="loco-alert#close"]');
  const count = await closeButtons.count();
  expect(count).toBeGreaterThan(0);

  for (let i = 0; i < count; i++) {
    const btn = closeButtons.nth(i);
    const alert = btn.locator('xpath=ancestor::*[contains(concat(" ", normalize-space(@class), " "), " alert ")][1]');
    // The message content is the element immediately before the close button.
    const content = btn.locator('xpath=preceding-sibling::*[1]');

    const btnBox = await btn.boundingBox();
    const alertBox = await alert.boundingBox();
    const contentBox = await content.boundingBox();
    expect(btnBox).not.toBeNull();
    expect(alertBox).not.toBeNull();
    expect(contentBox).not.toBeNull();

    // Pinned to the top-right corner of the alert (allow a small inset).
    expect(btnBox!.y - alertBox!.y).toBeLessThanOrEqual(16);
    expect(alertBox!.x + alertBox!.width - (btnBox!.x + btnBox!.width)).toBeLessThanOrEqual(16);

    // The button must start at or after the content ends (1px slack for rounding).
    expect(btnBox!.x).toBeGreaterThanOrEqual(contentBox!.x + contentBox!.width - 1);
  }
});
