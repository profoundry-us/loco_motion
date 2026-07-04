import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('/examples/Daisy::Feedback::SkeletonComponent');
});

test('chat avatar skeleton does not have neutral background class', async ({ page }) => {
  // When wrapper_css includes "skeleton", AvatarComponent suppresses the
  // where:bg-neutral where:text-neutral-content defaults so the skeleton
  // shimmer color shows correctly. Guard against that fix regressing.
  const avatarWrapper = page.locator('.chat-image > div.skeleton').first();

  await expect(avatarWrapper).toBeVisible();
  await expect(avatarWrapper).not.toHaveClass(/where:bg-neutral/);
});
