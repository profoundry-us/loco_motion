import { test, expect } from '@playwright/test';

/**
 * Universal smoke test: every link in the left nav must respond with HTTP 200.
 *
 * The nav is generated from `LocoMotion::COMPONENTS` plus the docs / guides
 * pages, so new components and pages are covered here automatically — no
 * per-page "page loads" spec is needed. Anything beyond "the page renders"
 * (interactions, regressions, geometry) belongs in the per-component specs.
 *
 * The whole sweep takes a few seconds; run it alone with
 * `yarn playwright test e2e/smoke`.
 */
test('every nav item responds with 200', async ({ page }) => {
  // Harvest from a docs page — the home page renders without the sidenav.
  await page.goto('/docs/install');

  const hrefs = await page
    .locator('#navmenu a[href]')
    .evaluateAll((links) => links.map((a) => a.getAttribute('href')!));

  // Dedupe, include the home page itself, and keep internal paths only (the
  // nav is all-internal today; this keeps a future external link from
  // flapping the suite).
  const paths = [...new Set(['/', ...hrefs])].filter((href) => href.startsWith('/'));

  // If the nav ever renders empty or partial, fail loudly instead of quietly
  // passing on a handful of URLs — the component registry alone holds 70+.
  expect(paths.length, 'nav rendered fewer links than expected').toBeGreaterThan(60);

  // Fetch with a small concurrency pool: fast, without hammering the
  // single-process CI server. Collect all failures so one broken page
  // doesn't hide the rest.
  const failures: string[] = [];
  let next = 0;
  await Promise.all(
    Array.from({ length: 6 }, async () => {
      while (next < paths.length) {
        const path = paths[next++];
        const response = await page.request.get(path);
        if (response.status() !== 200) {
          failures.push(`${path} → ${response.status()}`);
        }
      }
    })
  );

  expect(failures, `nav pages not responding with 200:\n${failures.join('\n')}`).toEqual([]);
});
