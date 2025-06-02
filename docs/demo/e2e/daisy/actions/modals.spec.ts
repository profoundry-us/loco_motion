import { expect, test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the Modals link
  await loco.clickNavLink(page, 'Modals');

  // Expect the title and a few headings
  await loco.expectPageTitle(page, /Modals | LocoMotion/);
  await loco.expectPageHeadings(page, [
    'Simple Modal',
    'Custom Activator'
  ]);
});

test('opens modal', async ({ page }) => {
  await page.goto('/examples/Daisy::Actions::ModalComponent');

  const dialog = await page.locator('dialog.modal').filter({ has: page.getByRole('heading', { name: 'Simple Modal' }) })

  // Click the Simple Modal button
  await page.click('button:has-text("Open Modal")');

  // Expect the modal to be open
  await expect(dialog).toBeVisible();
})

test('closes modal', async ({ page }) => {
  await page.goto('/examples/Daisy::Actions::ModalComponent');

  const dialog = await page.locator('dialog.modal').filter({ has: page.getByRole('heading', { name: 'Simple Modal' }) })

  // Expect the modal to start out closed
  await expect(dialog).toBeHidden();

  // Click the Simple Modal button
  await page.click('button:has-text("Open Modal")');

  // Expect the modal to be open
  await expect(dialog).toBeVisible();

  // Click the Close button
  await page.click('button:has-text("Cancel")');

  // Expect the modal to be closed
  await expect(dialog).toBeHidden();
})


test('submits modal', async ({ page }) => {
  await page.goto('/examples/Daisy::Actions::ModalComponent');

  const dialog = await page.locator('dialog.modal').filter({ has: page.getByRole('heading', { name: 'Simple Modal' }) })

  // Expect the modal to start out closed
  await expect(dialog).toBeHidden();

  // Click the Simple Modal button
  await page.click('button:has-text("Open Modal")');

  // Expect the modal to be open
  await expect(dialog).toBeVisible();

  // Click the Submit button
  await page.click('button:has-text("Submit")');

  // Expect the modal to be closed
  await expect(dialog).toBeHidden();

  // Expect the page to have the submission text
  await expect(page.getByText('You submitted the modal!', { exact: true })).toBeVisible();
})

