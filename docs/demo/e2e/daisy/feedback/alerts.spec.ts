import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Alerts nav link
  await loco.clickNavLink(page, 'Alerts');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Alerts | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Alerts',
    'Alerts Without Icons',
    'Custom Icon Alerts',
    'Soft Alerts',
    'Outline Alerts',
    'Dash Alerts'
  ]);
});

// Regression for #186: the closable alert's ✕ used to be absolutely positioned
// with a zero-specificity `pr-10` reservation that lost to DaisyUI's `.alert`
// padding, so the button overlapped the message text. It now flows as a trailing
// grid column, so it must sit clear of the content.
test('closable alert close button does not overlap content', async ({ page }) => {
  await page.goto('/examples/Daisy::Feedback::AlertComponent');

  const closeButtons = page.locator('.alert button[data-action*="loco-alert#close"]');
  const count = await closeButtons.count();
  expect(count).toBeGreaterThan(0);

  for (let i = 0; i < count; i++) {
    const btn = closeButtons.nth(i);
    // The message content is the element immediately before the close button.
    const content = btn.locator('xpath=preceding-sibling::*[1]');

    const btnBox = await btn.boundingBox();
    const contentBox = await content.boundingBox();
    expect(btnBox).not.toBeNull();
    expect(contentBox).not.toBeNull();

    // The button must start at or after the content ends (1px slack for rounding).
    expect(btnBox!.x).toBeGreaterThanOrEqual(contentBox!.x + contentBox!.width - 1);
  }
});
