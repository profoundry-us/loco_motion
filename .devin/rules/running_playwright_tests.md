---
trigger: always_on
---

Utilize these rules when you are running Playwright End-to-End (e2e) tests.

1. MUST run tests inside the Docker demo container

2. MUST use Yarn

3. MUST add `--reporter dot`

4. MUST add `--workers 1` to ensure CI works

5. MUST follow the pattern `<docker prefix> yarn playwright test '<file or path>' --reporter dot --workers 1`
 - Example 1 (single file): `docker compose exec -it demo yarn playwright test 'e2e/daisy/actions/buttons.spec.ts' --reporter dot --workers 1`
 - Example 2 (while directory): `docker compose exec -it demo yarn playwright test 'e2e/daisy/data_display/' --reporter dot --workers 1`

6. MUST review the dot output to determine which tests passed or failed
