import { test, expect } from '@playwright/test';

test('has title', async ({ page }) => {
  await page.goto('/');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Home | LocoMotion/);
});

test('has info sections', async ({ page }) => {
  await page.goto('/');

  // Expect a few titles so we know the page properly loads
  await expect(page.getByRole('heading', { name: 'Easy, Flexible Components' })).toBeVisible();
  await expect(page.getByRole('heading', { name: 'Simple, Concise Views' })).toBeVisible();
  await expect(page.getByRole('heading', { name: 'Build Your OWN Components' })).toBeVisible();
});
