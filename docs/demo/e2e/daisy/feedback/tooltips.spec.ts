import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Tooltips nav link
  await loco.clickNavLink(page, 'Tooltips');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Tooltips | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Component Tooltips',
    'Wrapper Tooltips'
  ]);
});

test('tip tooltips reveal on keyboard focus', async ({ page }) => {
  await page.goto('/examples/Daisy::Feedback::TooltipComponent');

  // A tooltip applied directly to a focusable element via the `tip:` attribute.
  const button = page.locator('button.tooltip[data-tip="This is a tooltip!"]');
  await expect(button).toHaveCount(1);

  // The tooltip bubble is the `::before` pseudo-element; its opacity tells us
  // whether the tooltip is visible.
  const bubbleOpacity = () =>
    button.evaluate((el) => getComputedStyle(el, '::before').opacity);

  // Hidden by default, revealed on focus, hidden again on blur.
  expect(await bubbleOpacity()).toBe('0');

  await button.focus();
  await expect.poll(bubbleOpacity).toBe('1');

  await button.evaluate((el) => (el as HTMLButtonElement).blur());
  await expect.poll(bubbleOpacity).toBe('0');
});
