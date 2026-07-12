import { test, expect } from '@playwright/test';
import { spawnSync } from 'node:child_process';

/**
 * Icon treeshake audit: every icon referenced in the demo must resolve from
 * the vendored `app/assets/svg/icons` set (or LocoMotion's bundled icons).
 *
 * Locally this suite runs against the long-lived development server, where
 * the dev-only cache fallback quietly renders icons that were never synced —
 * so a forgotten `loco_motion:icons:sync` would surface for the first time
 * in production. Shelling out to `loco_motion:icons:verify`, which resolves
 * every reference without the cache, catches that gap at test time no matter
 * which RAILS_ENV the server under test happens to run in. Playwright's cwd
 * is docs/demo both locally and in CI, so `bin/rails` resolves directly.
 */
test('every referenced icon is vendored', async () => {
  // Boots a fresh Rails process — allow well beyond the default 30s.
  test.setTimeout(120_000);

  const result = spawnSync('bin/rails', ['loco_motion:icons:verify'], {
    encoding: 'utf8',
    timeout: 120_000,
  });

  const output = [result.stdout, result.stderr, result.error?.message]
    .filter(Boolean)
    .join('\n');

  expect(result.status, `loco_motion:icons:verify failed:\n${output}`).toBe(0);
});
