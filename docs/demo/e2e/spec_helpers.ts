import { Page } from '@playwright/test';

/**
 * Loco helper object containing all test helper functions for the LocoMotion project
 */
export const loco = {
  /**
   * Clicks a navigation link in the navmenu by its title
   */
  clickNavLink: async(page: Page, title: string) => {
    await page.locator("#navmenu").getByRole('link', { name: title, exact: true }).click();
  }
};
