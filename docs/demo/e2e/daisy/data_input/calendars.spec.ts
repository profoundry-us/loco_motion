import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Calendars nav link
  await loco.clickNavLink(page, 'Calendars');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Calendars | LocoMotion/);
  // For calendars we need to use specific selectors for the h2 headings to avoid ambiguity
  // Using the specific heading IDs to ensure unique selection
  await expect(page.locator('#calendar')).toBeVisible();
  await expect(page.locator('#calendar-with-input')).toBeVisible();
  await expect(page.locator('#calendar-range')).toBeVisible();
});
