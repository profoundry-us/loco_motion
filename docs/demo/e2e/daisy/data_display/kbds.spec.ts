import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Keyboard (KBD) nav link
  await loco.clickNavLink(page, 'Keyboard (KBD)');

  // Expect the title and key headings
  await loco.expectPageTitle(page, /Keyboard \(KBD\) | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Basic Example',
    'Various Sizes',
    'Inside a Sentence'
  ]);
});
