import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the OTP Inputs nav link
  await loco.clickNavLink(page, 'OTP Inputs');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /OTP Inputs | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic OTP',
    '6-Digit OTP',
    'Joined OTP',
    'OTP Sizes',
    'OTP Colors',
    'OTP in a Form'
  ]);
});
