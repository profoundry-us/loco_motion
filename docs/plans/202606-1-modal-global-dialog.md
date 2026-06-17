# Modal: Global Dialog & Programmatic Open API

## Overview

This plan extends `Daisy::Actions::ModalComponent` so a single modal can live
once in a layout, render with **no built-in trigger**, and be opened
programmatically — including the canonical Hotwire pattern of lazy-loading a
form into a `<turbo-frame>` and opening the dialog when the frame loads.

It is split into **three dependency-ordered PRs**. Each PR ships its own
tests **and** documentation (YARD + demo + guide updates) — documentation is
not deferred to a follow-up.

This is additive and backward compatible: the default modal (co-located
button, opens on click via the existing inline `onclick`) renders and behaves
exactly as it does today.


## Related Issues

- Implements
  [#161](https://github.com/profoundry-us/loco_motion/issues/161) — Modal:
  support a headless/standalone dialog with a programmatic open API.
- Resolves the core of
  [#16](https://github.com/profoundry-us/loco_motion/issues/16) — Modal
  Component should use a Stimulus controller (currently labeled `wontfix` +
  `needs investigation`; #161 is the concrete use case it was waiting on).
- PRs A and B **reference** #161; PR C closes it with `Fixes #161`. All three
  mention #16. Revisit the `wontfix` label on #16 once PR B lands.


## Naming (decided)

- **Flag: `trigger: false`** (default `trigger: true`). In the Hotwire
  ecosystem a triggerless dialog is the *norm*, not a special mode, and
  "trigger" is the standard word for the opener (Radix/shadcn `DialogTrigger`,
  Bootstrap toggle/target) — so a plain boolean reads natively and does not
  collide with the existing `activator` / `button` slot names.
- **Documented pattern name: "Global Modal"** — the community term
  (hotrails, AppSignal, bramjetten). Used in the demo example title and the
  YARD `@loco_example` headings; the flag stays mechanical, the prose carries
  the intent.
- **Rejected:** `headless:` (collides with "Headless UI" = unstyled,
  behavior-only components — the opposite of our fully-styled modal);
  `standalone:` / `shared:` (invent a mode name the ecosystem does not use).
- **Controller actions `open` / `close`** and the
  `turbo:frame-load->loco-modal#open` / `turbo:submit-end->loco-modal#close`
  wiring intentionally match `tailwindcss-stimulus-components` and
  `@stimulus-components/dialog` so the API feels familiar.


## Current Behavior (the gaps, with references)

All in `app/components/daisy/actions/modal_component.rb` unless noted.

1. **No triggerless render.** `setup_activator_or_button` resolves
   `button || default_button`, and `default_button` calls
   `with_button(simple_title)`, which *sets* the button slot — so the
   template (`modal_component.html.haml:1-4`) always emits an activator or a
   button. There is no way to render only the `<dialog>`.
2. **No programmatic open API.** Line 139 hardcodes
   `onclick="document.getElementById('#{dialog_id}').showModal()"`. No
   Stimulus controller, no `open()` / `close()`.
3. **No Turbo-frame integration.** Only inline content is supported.
4. **No lifecycle events.** Nothing is emitted on open/close.
5. **Activator `tabindex` cannot be overridden.** The slot is built with
   `html: { role: "button", tabindex: 0 }` (line 80); a call-time
   `tabindex: -1` loses the merge.


## Design Principles

- **Backward compatible.** Default rendering and behavior are unchanged. The
  default co-located button keeps its inline `onclick` so existing apps need
  no JavaScript registration.
- **Opt-in controller.** A new `loco-modal` Stimulus controller powers the
  open/close API, events, and Turbo-frame auto-open. It is attached to the
  `<dialog>` but is **inert** if an app has not registered it — so it never
  breaks a consumer who skips the JS step.
- **Finish #16 later.** Migrating the *default* button off inline `onclick`
  onto the controller is a small follow-up reserved for the next minor (minor
  releases may break); it is out of scope here to keep these PRs non-breaking.
- **Docs travel with code.** Every PR updates YARD, the demo example, and any
  affected guide in the same PR.


## PR A — Global Modal (`trigger: false`) + activator `tabindex` fix

Pure Ruby/HAML. No JavaScript. Smallest, safest first step; removes the
hidden-activator workaround from the issue.

### A1. Component class

**File:** `app/components/daisy/actions/modal_component.rb`

- Add a `trigger` config option (default `true`); expose
  `attr_reader :trigger` + `trigger?`.
- In `setup_activator_or_button`, when `trigger?` is false: do **not** call
  `default_button`, and skip adding the `onclick` when neither an `activator`
  nor a `button` slot was supplied (no element to wire).
- Fix gap #5: let a call-time `tabindex` win. Either drop `tabindex` from the
  `renders_one :activator` build defaults and apply it in
  `setup_activator_or_button` only when absent, or reverse the merge so
  call-time `html:` takes precedence. Keep `role: "button"` and the default
  `tabindex: 0` for the normal case.

### A2. Template

**File:** `app/components/daisy/actions/modal_component.html.haml`

- The leading `if activator? / else = button` block already no-ops when
  neither slot is set once `default_button` is suppressed — verify it renders
  nothing in Global Modal mode and emits only `= part(:component)`.

### A3. Spec

**File:** `spec/components/daisy/actions/modal_component_spec.rb`

- New context `"when trigger is false"`: renders `dialog.modal`, renders **no**
  `button` and **no** activator, still renders the close icon and box.
- New context: a call-time `activator` `tabindex: -1` is honored.

### A4. Demo example

**File:** `docs/demo/app/views/examples/daisy/actions/modals.html.haml`

- Add a **"Global Modal"** example: a `daisy_modal(trigger: false,
  dialog_id: "global-demo")` plus a separate button that opens it. Until the
  controller lands (PR B), open it with a minimal inline
  `onclick="document.getElementById('global-demo').showModal()"` and note in
  the description that PR B will replace this with a Stimulus action.

### A5. YARD

**File:** `app/components/daisy/actions/modal_component.rb`

- Add `@option kws trigger [Boolean]` describing the triggerless render, with
  a blank line between entries.
- Add an `@loco_example Global Modal` showing `trigger: false`.

### A6. Verify

```bash
just loco-test
just demo-test
```

Roughly 5 files, well under the 500-line / 10-file limit.


## PR B — Stimulus Controller: `open` / `close` + lifecycle events

Layers the clean JS API on top of Global Modal mode and gives #16 its
controller.

### B1. Controller

**File (new):** `app/components/daisy/actions/modal_controller.js`

- Mirror the existing `loco-*` controllers (see
  `app/components/daisy/data_display/countdown_controller.js`).
- Attached to the `<dialog>`; `this.element` is the dialog.
- `open()` → `this.element.showModal()` then `this.dispatch("open")`
  (emits `loco-modal:open`).
- `close()` → `this.element.close()`.
- In `connect()`, bind the dialog's native `close` event directly on
  `this.element` (it does **not** bubble) and re-dispatch a bubbling
  `loco-modal:close`; remove the listener in `disconnect()`.

### B2. Component class

**File:** `app/components/daisy/actions/modal_component.rb`

- In `setup_component`, add `data-controller="loco-modal"` to the `:component`
  part. This is additive and inert without registration. **Keep** the default
  button's inline `onclick` (backward compat — see Design Principles).

### B3. Register + document the controller

- **Demo:** register `loco-modal` in
  `docs/demo/app/javascript/controllers/index.js` next to the existing
  controllers.
- **Install guide:** update
  `docs/demo/app/views/docs/02_install.html.haml` — add `ModalController`
  to the import + `application.register("loco-modal", ModalController)`
  snippet, with a one-line note that registration is required only to use the
  modal's programmatic / Global Modal features.

### B4. Demo example

**File:** `docs/demo/app/views/examples/daisy/actions/modals.html.haml`

- Update the PR A "Global Modal" example to open via the controller instead
  of inline JS (e.g. `data: { action: "loco-modal#open" }` on an in-scope
  trigger), and add a short snippet listening for `loco-modal:close`.

### B5. e2e

**File:** `docs/demo/e2e/daisy/actions/modals.spec.ts`

- Add specs: programmatic open shows the dialog; `close()` hides it; the
  `loco-modal:close` event fires. Run on chromium (see Caveats re: headless
  WebKit and the `close` event).

### B6. YARD

- Document the `loco-modal` controller, the `open`/`close` actions, and the
  `loco-modal:open` / `loco-modal:close` events on the component.

### B7. Verify

```bash
just loco-test
just demo-test
docker compose exec -T demo yarn playwright test \
  'e2e/daisy/actions/modals.spec.ts' --reporter dot --workers 1
```

Roughly 7 files. Single concern (the controller + its wiring).


## PR C — Turbo-Frame Integration

Builds on B; delivers the Global Modal pattern end to end.

### C1. Component class

**File:** `app/components/daisy/actions/modal_component.rb`

- Add a `turbo_frame` config option. When present:
  - render a `<turbo-frame id="...">` inside `:box` (or expose the id so the
    consumer's frame is matched), and
  - pass the frame id to the controller via a Stimulus value
    (`data-loco-modal-turbo-frame-value`).

### C2. Controller

**File:** `app/components/daisy/actions/modal_controller.js`

- Add `static values = { turboFrame: String }`.
- On `connect()`, if a frame value is set, locate the frame and listen for
  `turbo:frame-load` → `open()`.
- On the dialog `close`, optionally clear the frame (`src`/contents) so
  reopening refetches. Document this behavior.

### C3. Spec

**File:** `spec/components/daisy/actions/modal_component_spec.rb`

- Context `"with a turbo_frame"`: renders a `turbo-frame` with the right id
  inside the box and sets the controller value attribute.

### C4. e2e

**File:** `docs/demo/e2e/daisy/actions/modals.spec.ts`

- A remote link targets the frame → frame loads → dialog opens; a successful
  submit closes it. Use the idiomatic
  `turbo:frame-load->loco-modal#open` / `turbo:submit-end->loco-modal#close`
  wiring. Chromium only.

### C5. Demo example

**File:** `docs/demo/app/views/examples/daisy/actions/modals.html.haml`

- Add a full "Global Modal (Turbo Frame)" example: a list of items whose
  edit links carry `data-turbo-frame`, and one global
  `daisy_modal(trigger: false, turbo_frame: "modal")`.
- A tiny demo controller action may be needed to serve frame content; keep it
  in the demo app only.

### C6. YARD

- Add `@option kws turbo_frame` and an `@loco_example` for the Turbo-frame
  pattern.

### C7. Verify

```bash
just loco-test
just demo-test
docker compose exec -T demo yarn playwright test \
  'e2e/daisy/actions/modals.spec.ts' --reporter dot --workers 1
```


## Backward Compatibility

- Default modal output and behavior are unchanged; existing specs pass as-is.
- The `loco-modal` controller is inert until an app registers it; consumers
  who skip the JS step keep working modals via the retained inline `onclick`.
- `trigger:` and `turbo_frame:` are new optional params with backward-compatible
  defaults.
- Fully moving the default trigger off inline `onclick` (the remainder of #16)
  is intentionally deferred to a future minor.


## Caveats

- **Headless WebKit `close` event.** Some headless WebKit builds do not fire
  the `<dialog>` `close`/`cancel` events even though `showModal()`/`close()`
  work (per the issue). Our Playwright suite runs **chromium**, so it is
  unaffected — but keep e2e assertions about close/cancel on chromium and do
  not port them to a WebKit project without revalidating.
- If the demo does not reflect `.rb` / `.haml` changes during development,
  restart it with `just demo-restart`.


## Per-PR Size Check

| PR | Concern | Approx. files |
|----|---------|---------------|
| A  | Global Modal mode + tabindex fix | ~5 |
| B  | Stimulus controller + events | ~7 |
| C  | Turbo-frame integration | ~7 |

Each stays within the 500-line / 10-file limit and represents one logical
concern.
