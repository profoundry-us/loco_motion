
# Update README Install Docs for Tailwind 4 / DaisyUI 5 (Issue #106)

## Overview

The README install documentation still describes the Tailwind 3 / DaisyUI 4
setup process. Since the release of v0.5.x (which ships Tailwind 4 and
DaisyUI 5), several sections are incorrect or misleading for new users:

1. The "Install DaisyUI" section still shows `tailwind.config.js` plugin
   setup — this is the Tailwind 3 approach and does not work with Tailwind 4.
2. The CSS-first `@import tailwindcss` / `@plugin 'daisyui'` approach is
   not documented at all.
3. The LocoMotion Install section references `bundle show loco_motion`
   (wrong gem name — should be `loco_motion-rails`).
4. The gem version example still shows `0.4.0`; the current release is
   `0.5.2`.
5. The DISCLAIMER / CURRENT STATUS section describes 0.5.0 as future work
   when it has already shipped.

Fixes #106 — https://github.com/profoundry-us/loco_motion/issues/106

## External Resources

- Issue: https://github.com/profoundry-us/loco_motion/issues/106
- Tailwind 4 CSS-first config docs: https://tailwindcss.com/docs/configuration
- DaisyUI 5 install docs: https://daisyui.com/docs/install/
- Working CSS reference:
  `docs/demo/app/assets/stylesheets/application.tailwind.css`
- Working config reference: `docs/demo/tailwind.config.js`

## Implementation Steps

### 1. Analyze Current README

**Purpose**: Identify the exact line ranges of each section that needs
updating so edits are targeted and don't break surrounding content.

**File to Review**: `README.md`

**Key sections and approximate line numbers**:

- `DISCLAIMER / CURRENT STATUS` — lines 10–26
- `Install DaisyUI (Optional)` — lines 311–368
- `LocoMotion Install` section (gem version + `tailwind.config.js`) —
  lines 751–785

### 2. Remove / Rewrite DISCLAIMER Section

**Purpose**: The DISCLAIMER describes 0.5.0 as unreleased future work.
Since 0.5.x has shipped, this section is misleading. Replace it with a
brief "current status" note that reflects reality.

**File to Edit**: `README.md`

**Changes to Make**:

- Remove the `<!-- omit from toc -->` DISCLAIMER block (lines 9–26).
- Replace with a short note (2–4 lines) that states the project ships
  Tailwind 4 + DaisyUI 5 as of v0.5.x and is in active development.
- Keep the `<!-- omit from toc -->` directive on the replacement header
  so the TOC is unaffected.

### 3. Rewrite "Install DaisyUI" Section

**Purpose**: Replace the Tailwind 3 / DaisyUI 4 plugin approach with the
Tailwind 4 CSS-first approach.

**File to Edit**: `README.md`

**Changes to Make**:

- Replace the `yarn add daisyui@latest --dev` command with the correct
  Tailwind 4 command (no `--dev`, no `@latest`):
  ```shell
  yarn add tailwindcss @tailwindcss/cli daisyui
  ```
- Remove the `tailwind.config.js` plugin block
  (`plugins: [require("daisyui")]`) entirely.
- Add a new sub-section or note showing the CSS-first setup. Use the demo
  app's `application.tailwind.css` as the reference. The minimal example
  for a user app:
  ```css
  /* application.tailwind.css */

  /* Import the base Tailwind theme */
  @import 'tailwindcss';

  /* Include DaisyUI via @plugin directive */
  @plugin 'daisyui' {
    themes: light --default, dark --prefersdark;
  }

  /* Point to tailwind.config.js for content scan paths only */
  @config "../tailwind.config.js";
  ```
- Clarify that `tailwind.config.js` is now minimal — only responsible for
  `content` scan paths; plugins live in the CSS file.
- Update the `> [!IMPORTANT]` note that says "Moving forward, this guide
  will assume you have installed DaisyUI" — keep the intent but adjust
  wording to reflect DaisyUI 5 / Tailwind 4.

### 4. Update LocoMotion Install Section

**Purpose**: Fix the gem name, version, and `tailwind.config.js` snippet
so they reflect the current working setup.

**File to Edit**: `README.md`

**Changes to Make**:

- In the Gemfile example, update the pinned version from `0.4.0` to
  `0.5.2`:
  ```ruby
  gem "loco_motion-rails", "~> 0.5.2", require: "loco_motion"
  ```
- Remove or update the stale GitHub source line
  (`github: "profoundry-us/loco_motion", branch: "main"`) — point users
  to RubyGems instead.
- Fix the `tailwind.config.js` snippet:
  - Change `bundle show loco_motion` → `bundle show loco_motion-rails`
  - Show the minimal content-only config (no `plugins:` key), matching
    `docs/demo/tailwind.config.js`:
    ```js
    const { execSync } = require('child_process');
    let locoBundlePath =
      execSync('bundle show loco_motion-rails').toString().trim();

    module.exports = {
      content: [
        `${locoBundlePath}/app/components/**/*.{rb,js,html,haml}`,
        'app/components/**/*.{rb,js,html,haml}',
        'app/views/**/*.{rb,js,html,haml}',
      ]
    }
    ```
  - Add a note that plugins (DaisyUI, Typography) must be declared in the
    CSS file via `@plugin`, not in `tailwind.config.js`.
- Update the `> [!WARNING]` note about `bundle show` to reference
  `loco_motion-rails`.
- Remove the stale CAUTION callout that says the components are "NOT ready
  for production / public use" if it no longer applies, or update it to
  reflect the current state of the library.

### 5. (Optional) Add application.tailwind.css Example

**Purpose**: Give new users a concrete starting point for the CSS file,
especially since there is no existing documentation for the CSS-first
approach.

**File to Edit**: `README.md`

**Changes to Make**:

- After the DaisyUI `@plugin` block, add a collapsible or inline example
  showing a complete minimal `application.tailwind.css`:
  ```css
  /* Import the base Tailwind theme */
  @import 'tailwindcss';

  /* Include DaisyUI and optionally Typography */
  @plugin '@tailwindcss/typography';
  @plugin 'daisyui' {
    themes: light --default, dark --prefersdark;
  }

  /* Point to tailwind.config.js for content scan paths */
  @config "../tailwind.config.js";
  ```

### 6. Verification

**Purpose**: Confirm the README renders correctly and all links work.

**Steps**:

- Preview the README in GitHub or a Markdown renderer to confirm headers,
  code blocks, and callouts render as expected.
- Verify the TOC links still resolve correctly (especially if section
  headings changed).
- Do a final pass grepping for any remaining `0.4.0`, `loco_motion` (bare,
  without `-rails`), or `tailwind.config.js plugins` references that may
  have been missed:
  ```bash
  grep -n "0\.4\.0\|bundle show loco_motion[^-]\|plugins.*daisyui\|require.*daisyui" README.md
  ```

**Expected Results**:

- No references to the Tailwind 3 DaisyUI plugin approach remain.
- All `bundle show` commands reference `loco_motion-rails`.
- The DISCLAIMER section is gone or accurately describes the current state.
- The gem version in the install example is `~> 0.5.2`.
- The `tailwind.config.js` snippet shows content paths only (no plugins).
