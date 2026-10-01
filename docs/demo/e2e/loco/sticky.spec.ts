import { test, expect, Page } from '@playwright/test';

// The `loco-sticky` controller stamps `data-stuck="<edges>"` on a sticky
// element while it is pinned, which is what loco.css's `stuck:` variants key
// on (issue #377). Detection is an IntersectionObserver whose root is
// collapsed to a 1px line at the element's sticky offset, so these specs drive
// real scrolling in real layouts rather than unit-testing the class.
//
// Each spec injects its own fixture into a live demo page: the page already
// runs the demo's Stimulus application with `loco-sticky` registered, and
// Stimulus connects controllers on dynamically inserted elements.

const PAGE = '/examples/Daisy::DataInput::TextInputComponent';

// Where the element's top edge sits in the document when it is NOT stuck,
// measured by briefly laying it out as `position: static`.
async function staticTop(page: Page, selector: string): Promise<number> {
  return page.evaluate((sel) => {
    const el = document.querySelector<HTMLElement>(sel)!;
    const previous = el.style.position;
    el.style.position = 'static';
    const top = el.getBoundingClientRect().top + window.scrollY;
    el.style.position = previous;
    return top;
  }, selector);
}

async function stuckValue(page: Page, selector: string): Promise<string | null> {
  return page.evaluate((sel) => document.querySelector<HTMLElement>(sel)!.dataset.stuck ?? null, selector);
}

test.describe('loco-sticky controller', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
  });

  // A flex-column parent and a `top: 64px` offset: the attribute must flip
  // exactly at the offset line, not at the viewport edge, and the controller
  // must not add any nodes to the layout (a stray flex item would shift the
  // column by its `gap`).
  test('stamps data-stuck="top" exactly when a flex-column child pins at its offset', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'beforeend',
        `<div id="fixture" style="display:flex;flex-direction:column;gap:16px;width:600px">
           <div style="height:300px">spacer A</div>
           <div style="height:200px">spacer B</div>
           <nav id="nav" style="position:sticky;top:64px;height:40px;background:tomato" data-controller="loco-sticky">nav</nav>
           <div style="height:3000px">tall</div>
         </div>`
      );
    });

    const nav = page.locator('#nav');
    await expect(nav).toHaveAttribute('data-controller', 'loco-sticky');
    expect(await page.locator('#fixture').evaluate((el) => el.childElementCount)).toBe(4);

    // Not stuck at rest.
    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#nav')).toBeNull();

    const navTop = Math.round(await staticTop(page, '#nav'));

    // 10px before the nav's static top reaches the 64px offset line: still in flow.
    await page.evaluate((y) => window.scrollTo(0, y), navTop - 64 - 10);
    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#nav')).toBeNull();

    // 10px past the line: pinned at exactly the offset.
    await page.evaluate((y) => window.scrollTo(0, y), navTop - 64 + 10);
    await expect.poll(() => stuckValue(page, '#nav')).toBe('top');
    expect(await nav.evaluate((el) => Math.round(el.getBoundingClientRect().top))).toBe(64);

    // Deep into the tall content: still pinned.
    await page.evaluate((y) => window.scrollTo(0, y), navTop + 1500);
    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#nav')).toBe('top');

    // Back to the top of the page: released.
    await page.evaluate(() => window.scrollTo(0, 0));
    await expect.poll(() => stuckValue(page, '#nav')).toBeNull();
  });

  // The pane is deliberately NOT `position: relative` — the case an
  // absolutely positioned sentinel gets wrong.
  test('uses the nearest scrollable ancestor as the observer root', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'afterbegin',
        `<div id="pane" style="height:200px;width:400px;overflow:auto">
           <div style="height:50px">before</div>
           <div id="head" style="position:sticky;top:0;height:30px;background:gold" data-controller="loco-sticky">head</div>
           <div style="height:1000px">content</div>
         </div>`
      );
    });

    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#head')).toBeNull();

    await page.locator('#pane').evaluate((el) => { el.scrollTop = 100; });
    await expect.poll(() => stuckValue(page, '#head')).toBe('top');

    // Scrolling the WINDOW must not affect a header rooted in the pane.
    await page.evaluate(() => window.scrollTo(0, 400));
    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#head')).toBe('top');
    await page.evaluate(() => window.scrollTo(0, 0));

    await page.locator('#pane').evaluate((el) => { el.scrollTop = 0; });
    await expect.poll(() => stuckValue(page, '#head')).toBeNull();
  });

  // IntersectionObserver reports on observe(), so an element that connects
  // while its scroller is already past it is stamped without any scroll.
  test('stamps immediately when connected mid-scroll', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'afterbegin',
        `<div id="pane" style="height:200px;width:400px;overflow:auto">
           <div style="height:50px">before</div>
           <div id="slot"></div>
           <div style="height:1000px">content</div>
         </div>`
      );
      document.getElementById('pane')!.scrollTop = 300;
    });

    await page.evaluate(() => {
      document.getElementById('slot')!.outerHTML =
        `<div id="late" style="position:sticky;top:0;height:30px;background:orange" data-controller="loco-sticky">late</div>`;
    });

    await expect.poll(() => stuckValue(page, '#late')).toBe('top');
  });

  test('detects the left edge inside a horizontal scroller', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'afterbegin',
        `<div id="pane" style="width:300px;overflow-x:auto">
           <div style="display:flex;width:1500px">
             <div style="width:100px;flex:none">gutter</div>
             <div id="col" style="position:sticky;left:0;width:120px;flex:none;background:skyblue"
                  data-controller="loco-sticky" data-loco-sticky-edge-value="left">col</div>
             <div style="width:1280px;flex:none">cells</div>
           </div>
         </div>`
      );
    });

    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#col')).toBeNull();

    await page.locator('#pane').evaluate((el) => { el.scrollLeft = 150; });
    await expect.poll(() => stuckValue(page, '#col')).toBe('left');

    await page.locator('#pane').evaluate((el) => { el.scrollLeft = 0; });
    await expect.poll(() => stuckValue(page, '#col')).toBeNull();
  });

  // A cell pinned on two edges reports both, in the order the value lists them.
  test('reports both edges of a corner cell', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'afterbegin',
        `<div id="pane" style="width:300px;height:200px;overflow:auto">
           <div style="width:1500px;height:1500px">
             <div style="height:40px">row 0</div>
             <!-- The row must be taller than the cell: a sticky element only
                  moves within its containing block. -->
             <div style="display:flex;align-items:flex-start;height:1400px">
               <div style="width:100px;flex:none">gutter</div>
               <div id="corner" style="position:sticky;top:0;left:0;width:120px;height:30px;flex:none;background:plum"
                    data-controller="loco-sticky" data-loco-sticky-edge-value="top left">corner</div>
             </div>
           </div>
         </div>`
      );
    });

    await page.waitForTimeout(150);
    expect(await stuckValue(page, '#corner')).toBeNull();

    await page.locator('#pane').evaluate((el) => { el.scrollTop = 100; });
    await expect.poll(() => stuckValue(page, '#corner')).toBe('top');

    await page.locator('#pane').evaluate((el) => { el.scrollLeft = 150; });
    await expect.poll(() => stuckValue(page, '#corner')).toBe('top left');

    await page.locator('#pane').evaluate((el) => { el.scrollTop = 0; });
    await expect.poll(() => stuckValue(page, '#corner')).toBe('left');
  });

  test('clears the attribute on disconnect', async ({ page }) => {
    await page.evaluate(() => {
      document.body.insertAdjacentHTML(
        'afterbegin',
        `<div id="pane" style="height:200px;width:400px;overflow:auto">
           <div id="head" style="position:sticky;top:0;height:30px" data-controller="loco-sticky">head</div>
           <div style="height:1000px">content</div>
         </div>`
      );
    });

    await page.locator('#pane').evaluate((el) => { el.scrollTop = 100; });
    await expect.poll(() => stuckValue(page, '#head')).toBe('top');

    // Dropping the controller attribute disconnects it without removing the element.
    await page.locator('#head').evaluate((el) => el.removeAttribute('data-controller'));
    await expect.poll(() => stuckValue(page, '#head')).toBeNull();
  });
});
