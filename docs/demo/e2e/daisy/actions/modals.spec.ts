import { expect, test, Locator, Page } from '@playwright/test';

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

/**
 * Invoke the global modal's `loco-modal` Stimulus controller once it has
 * connected, so tests can open/close it programmatically.
 */
async function callController(page: Page, method: 'open' | 'close') {
  await page.waitForFunction(() => {
    const dialog = document.getElementById('global-demo');
    return !!(dialog && (window as any).Stimulus
      && (window as any).Stimulus.getControllerForElementAndIdentifier(dialog, 'loco-modal'));
  });

  await page.evaluate((m) => {
    const dialog = document.getElementById('global-demo');
    (window as any).Stimulus
      .getControllerForElementAndIdentifier(dialog, 'loco-modal')[m]();
  }, method);
}

/**
 * Test suite for the Global Modal (`trigger: false`) and its `loco-modal`
 * controller: the programmatic open/close API and the bubbling
 * `loco-modal:close` lifecycle event.
 */
test.describe('global modal controller', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/examples/Daisy::Actions::ModalComponent');
  });

  test('opens programmatically through the controller', async ({ page }) => {
    const modal = page.locator('#global-demo');
    await expect(modal).toBeHidden();

    await callController(page, 'open');

    await expect(modal).toBeVisible();
  });

  test('closes programmatically through the controller', async ({ page }) => {
    const modal = page.locator('#global-demo');

    await page.click('button:has-text("Open Global Modal")');
    await expect(modal).toBeVisible();

    await callController(page, 'close');

    await expect(modal).toBeHidden();
  });

  test('re-dispatches a bubbling loco-modal:close on close', async ({ page }) => {
    const modal = page.locator('#global-demo');

    await page.click('button:has-text("Open Global Modal")');
    await expect(modal).toBeVisible();

    // Close through the dialog's own Close button (a native dialog-method form).
    // Scope to the box so we don't match the dialog's "close" backdrop button.
    await modal.locator('.modal-box').getByRole('button', { name: 'Close', exact: true }).click();
    await expect(modal).toBeHidden();

    // The controller turned the non-bubbling native `close` into a bubbling
    // `loco-modal:close`, which the demo's document-level listener caught.
    await expect(page.getByText('loco-modal:close fired', { exact: false })).toBeVisible();
  });
});

/**
 * Test suite for the Global Modal Turbo Frame pattern: a remote link streams an
 * edit form into the modal's `<turbo-frame>`, the `loco-modal` controller opens
 * the dialog on `turbo:frame-load`, and a successful submit closes it
 * (`turbo:submit-end -> loco-modal#close`).
 */
test.describe('global modal turbo frame', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/examples/Daisy::Actions::ModalComponent');

    // Wait for the dialog's controller to connect so its frame-load listener is
    // wired before we trigger a frame navigation.
    await page.waitForFunction(() => {
      const dialog = document.getElementById('contact-modal-dialog');
      return !!(dialog && (window as any).Stimulus
        && (window as any).Stimulus.getControllerForElementAndIdentifier(dialog, 'loco-modal'));
    });
  });

  test('opens when a link loads the frame, and closes on submit', async ({ page }) => {
    const dialog = page.locator('#contact-modal-dialog');
    await expect(dialog).toBeHidden();

    // A remote edit link streams its form into the modal's turbo-frame.
    await page.getByRole('link', { name: 'Edit Contact 1' }).click();

    // The controller opens the dialog once the frame finishes loading.
    await expect(dialog).toBeVisible();
    await expect(dialog.getByText('Edit Alice Anderson')).toBeVisible();

    // Submitting the form closes the dialog (turbo:submit-end -> loco-modal#close).
    await dialog.getByRole('button', { name: 'Save' }).click();
    await expect(dialog).toBeHidden();
  });
});
