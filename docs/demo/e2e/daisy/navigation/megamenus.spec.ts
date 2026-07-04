import { test, expect } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('items open their popovers', async ({ page }) => {
  await page.goto('/');
  await loco.clickNavLink(page, 'Megamenus');

  // The Services popover starts closed and opens on click
  const services = page.getByRole('button', { name: 'Services' });
  await services.click();

  await expect(page.getByRole('link', { name: 'CRM Software' })).toBeVisible();
});
