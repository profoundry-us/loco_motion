import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Megamenus nav link
  await loco.clickNavLink(page, 'Megamenus');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Megamenus | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Megamenu',
    'Wide Megamenu',
    'Full-Width Megamenu',
    'Rich Content',
    'Custom Toggle'
  ]);
});

test('items open their popovers', async ({ page }) => {
  await page.goto('/');
  await loco.clickNavLink(page, 'Megamenus');

  // The Services popover starts closed and opens on click
  const services = page.getByRole('button', { name: 'Services' });
  await services.click();

  await expect(page.getByRole('link', { name: 'CRM Software' })).toBeVisible();
});
