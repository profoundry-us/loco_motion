import { test, expect } from '@playwright/test';

// A calendar pick must be observable by form-level listeners (issue #388).
// The cally web component's `change` event fires on the <calendar-date>
// element but does not bubble, and programmatically syncing the input's
// value fires no event at all — so autosave / dirty-tracking / validation
// wired at the form level silently missed calendar picks. The controller
// now re-dispatches bubbling `input` and `change` events from the input,
// mirroring a native date input.
test('calendar picks dispatch bubbling input and change events', async ({ page }) => {
  await page.goto('/examples/Daisy::DataInput::CallyInputComponent');

  const input = page.locator("input[name='event[start_date]']");
  const form = page.locator('form', { has: input });

  // Probe: record every input/change event that reaches the FORM element —
  // exactly what an autosaving form listens for.
  await form.evaluate((el) => {
    (window as any).__events = [];
    for (const type of ['input', 'change']) {
      el.addEventListener(type, (e) => {
        (window as any).__events.push({
          type: e.type,
          name: (e.target as HTMLInputElement).name,
        });
      });
    }
  });

  // Open the calendar popover and pick a real day through cally's UI (its
  // shadow roots are open, so role locators pierce them). The popover must
  // be the one inside THIS input's component, not the page's first.
  const component = page.locator("[data-controller~='loco-cally-input']", {
    has: input,
  });
  const popover = component.locator("[data-loco-cally-input-target='popover']");

  // Position the input near the top of the viewport first so the popover
  // opens fully on-screen — otherwise the controller's smooth auto-scroll
  // keeps the day buttons unstable/off-viewport while Playwright retries.
  await input.evaluate((el) => el.scrollIntoView({ block: 'start' }));
  await input.click();
  await expect(popover).toBeVisible();

  // Day buttons are accessibly named "<Month> <day>", e.g. "August 15".
  await popover.getByRole('button', { name: /^[A-Z][a-z]+ 15$/ }).click();

  // The pick syncs the input and closes the popover...
  await expect(popover).not.toBeVisible();
  await expect(input).toHaveValue(/^\d{4}-\d{2}-15$/);

  // ...and the form saw a bubbling input AND change event from that input.
  const events = await form.evaluate(() => (window as any).__events);
  expect(events).toEqual(
    expect.arrayContaining([
      { type: 'input', name: 'event[start_date]' },
      { type: 'change', name: 'event[start_date]' },
    ])
  );
});
