import { test, expect, Page } from '@playwright/test';

// The acceptance test for issue #377: the Sticky Elements docs page combines a
// compacting navbar, section headings that track it through a `group/page`
// ancestor, and a table pinned on two edges inside its own scroller. Each
// region must flip `data-stuck` and pick up a computed style from a `stuck`
// variant, with no interference between the two scroll roots.

const PANE = '#sticky-demo';

const stuck = (page: Page, selector: string) =>
  page.locator(selector).first().evaluate((el) => (el as HTMLElement).dataset.stuck ?? null);

const style = (page: Page, selector: string, property: string) =>
  page.locator(selector).first().evaluate((el, p) => getComputedStyle(el).getPropertyValue(p), property);

// Position of an element's top edge relative to the pane's scrollport.
const topInPane = (page: Page, selector: string) =>
  page.locator(selector).first().evaluate((el, pane) => {
    const root = document.querySelector(pane)!;
    return Math.round(el.getBoundingClientRect().top - root.getBoundingClientRect().top - root.clientTop);
  }, PANE);

const scrollPane = (page: Page, selector: string, top: number, left = 0) =>
  page.locator(selector).first().evaluate((el, [t, l]) => { el.scrollTop = t; el.scrollLeft = l; }, [top, left]);

test.describe('Sticky Elements page', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/docs/sticky_elements');
    await page.locator(PANE).scrollIntoViewIfNeeded();
  });

  test('the navbar compacts only once it pins, and the headings track it', async ({ page }) => {
    const nav = `${PANE} .navbar`;
    const heading = `${PANE} h3`;

    // At rest the navbar sits exactly at its offset but is not stuck.
    await page.waitForTimeout(200);
    expect(await stuck(page, nav)).toBeNull();
    expect(await style(page, nav, 'height')).toBe('64px');
    expect(await stuck(page, heading)).toBeNull();

    await scrollPane(page, PANE, 200);
    await expect.poll(() => stuck(page, nav)).toBe('top');
    await expect.poll(() => style(page, nav, 'height')).toBe('48px');

    // The first heading pins below the compacted navbar, not at its 4rem
    // resting offset, and restyles itself.
    await expect.poll(() => stuck(page, heading)).toBe('top');
    await expect.poll(() => topInPane(page, heading)).toBe(48);
    expect(await style(page, heading, 'box-shadow')).not.toBe('none');

    // Layering: the navbar stays above the headings.
    expect(Number(await style(page, nav, 'z-index'))).toBeGreaterThan(Number(await style(page, heading, 'z-index')));

    await scrollPane(page, PANE, 0);
    await expect.poll(() => stuck(page, nav)).toBeNull();
    await expect.poll(() => stuck(page, heading)).toBeNull();
    await expect.poll(() => style(page, nav, 'height')).toBe('64px');
  });

  test('the roster table pins its header row and first column in its own scroller', async ({ page }) => {
    const box = `${PANE} .overflow-auto`;
    const headRow = `${box} thead tr`;
    const pinned = `${box} tbody td[data-controller~="loco-sticky"]`;

    // Bring the roster into the pane; the table has not scrolled yet.
    await page.locator(box).evaluate((el) => el.scrollIntoView({ block: 'center' }));
    await page.waitForTimeout(200);
    expect(await stuck(page, headRow)).toBeNull();
    expect(await stuck(page, pinned)).toBeNull();
    const restingColor = await style(page, `${headRow} th:nth-child(2)`, 'color');

    // Scrolling the PANE must not pin anything inside the inner scroller.
    await page.locator(PANE).evaluate((el) => { el.scrollTop += 40; });
    await page.waitForTimeout(200);
    expect(await stuck(page, headRow)).toBeNull();

    await scrollPane(page, box, 120, 0);
    await expect.poll(() => stuck(page, headRow)).toBe('top');
    await expect.poll(() => style(page, `${headRow} th:nth-child(2)`, 'color')).not.toBe(restingColor);

    // Back to the first row (a cell scrolled out of the box is not pinned)
    // and sideways: the first column pins and draws its divider.
    await scrollPane(page, box, 0, 120);
    await expect.poll(() => stuck(page, pinned)).toBe('left');
    expect(await style(page, pinned, 'border-right-width')).toBe('1px');
    expect(await stuck(page, headRow)).toBeNull();

    await scrollPane(page, box, 0, 0);
    await expect.poll(() => stuck(page, headRow)).toBeNull();
    await expect.poll(() => stuck(page, pinned)).toBeNull();
  });
});
