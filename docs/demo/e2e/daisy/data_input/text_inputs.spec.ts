import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

// Returns the computed opacity of a floating label's <span> for the input with
// the given id. DaisyUI collapses the span to opacity 0 and only raises it
// (opacity 1) on focus or once the field has a value.
const floatingLabelOpacity = (page, inputId: string) =>
  page
    .locator('label.floating-label', { has: page.locator(`#${inputId}`) })
    .locator('span')
    .first()
    .evaluate((el) => getComputedStyle(el).opacity);

test('floating-sticky keeps the label raised while a placeholder shows', async ({ page }) => {
  // Start on a docs page — the home page renders without the sidenav.
  await page.goto('/docs/install');
  await loco.clickNavLink(page, 'Text Inputs');

  // The sticky field is empty and shows a placeholder, yet its label is raised.
  expect(await floatingLabelOpacity(page, 'email_sticky_input')).toBe('1');

  // A plain floating field with a placeholder keeps its label collapsed until
  // focus — proving floating-sticky (not some other change) is what raised it.
  expect(await floatingLabelOpacity(page, 'phone_floating_input')).toBe('0');
});
