import { expect, test, Locator } from '@playwright/test';
import { loco } from '../../spec_helpers';

/**
 * Verify the Modals page loads correctly with expected elements
 */
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

/**
 * Test suite for the simple modal functionality
 */
test.describe('simple modal', () => {
  let modal: Locator;

  // Visit the page, verify modal is hidden, open modal
  test.beforeEach(async ({ page }) => {
    await page.goto('/examples/Daisy::Actions::ModalComponent');

    modal = await page.locator('dialog.modal').filter({ has: page.getByRole('heading', { name: 'Simple Modal' }) })

    // Expect the modal to start out closed
    await expect(modal).toBeHidden();

    // Open the modal
    await page.click('button:has-text("Open Modal")');
  })

  /**
   * Verify the modal opens correctly
   */
  test('opens modal', async () => {
    // Expect the modal to be open
    await expect(modal).toBeVisible();
  })

  /**
   * Verify the modal closes when Cancel button is clicked
   */
  test('closes modal', async ({ page }) => {
    // Click the Close button
    await page.click('button:has-text("Cancel")');

    // Expect the modal to be closed
    await expect(modal).toBeHidden();
  })

  /**
   * Verify the modal submits correctly and displays confirmation
   */
  test('submits modal', async ({ page }) => {
    // Click the Submit button
    await page.click('button:has-text("Submit")');

    // Expect the modal to be closed
    await expect(modal).toBeHidden();

    // Expect the page to have the submission text
    await expect(page.getByText('You submitted the modal!', { exact: true })).toBeVisible();
  })

})
