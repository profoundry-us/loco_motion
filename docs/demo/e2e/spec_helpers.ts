import { expect, Page } from '@playwright/test';

/**
 * Loco helper object containing all test helper functions for the LocoMotion project
 */
export const loco = {
  /**
   * Clicks a navigation link in the navmenu by its title
   */
  clickNavLink: async(page: Page, title: string) => {
    await page.locator("#navmenu").getByRole('link', { name: title, exact: true }).click();
  },

  /**
   * Expects the page to have the specified title
   */
  expectPageTitle: async (page: Page, title: string | RegExp) => {
    await expect(page).toHaveTitle(title);
  },

  /**
   * Expects the page to have the specified headings visible
   */
  expectPageHeadings: async (page: Page, headings: string[]) => {
    for (const heading of headings) {
      await expect(page.getByRole('heading', { name: heading })).toBeVisible();
    }
  }
};
