# Deferred Ideas & Open Questions


This is a backlog of genuinely-actionable ideas and open design questions that
were previously captured in a loose `NEXT_SESSION.md` scratchpad at the repo
root. They are consolidated here so they live alongside the rest of the plans
and follow the active-vs-archive convention (see
[`README.md`](README.md) in this directory).

These are not yet scheduled work — they are candidates to pick up in a future
session. Move an item into its own dated plan when you start it.


## Components

### Cally (calendar)

Find a better way to auto-close the calendar on date selection, and to sync
values when a user types to update the field.

### Dock / Iconable

Find a better way to set up and pass variants and default CSS to the iconable
component (and its render methods). One option is to have the builder methods
return an actual component.

We currently have several distinct rendering needs that this design should
reconcile:

1. **Slots** — a component needs to render something in a specific place.
2. **Builder methods** — the developer needs to render a customized component
   wherever they want.
3. **Parts** — essentially a simplified slot.
4. **Component-backed parts/slots** — a component needs to render a slot or
   "part" that is itself a full component, where part options are passed through
   to that component (you can't just call the part; it must render a component
   but accept the part's options).

Open question: are parts just default slots that accept CSS/HTML in the initial
call? Not quite — slots require their content to be passed, whereas a part
lets you override one small aspect (e.g. `left_icon_css: "size-12"`) without
re-supplying the entire slot content; the override appends to the existing part.


## Algolia / LLM Documentation

See [`ALGOLIA.md`](../dev_guides/ALGOLIA.md) for the current integration.

1. **Incorporate API docs into search** — consider indexing classes and
   relevant slot methods, and writing real docs around part CSS/HTML and slots.
2. **CI/CD indexing** — create a workflow to automatically index components
   during CI/CD, and ensure the binaries work correctly in CI environments.
3. **Documentation updates** — add more guides, document common usage patterns
   (in `docs/demo/data/usage_patterns.md`), and add a troubleshooting section.

### Open questions

1. Should we add support for versioned indices in Algolia?
2. Would a `--dry-run` option (show what would be indexed without doing it) be
   useful?
3. Are there performance improvements we could make to the indexing process?
4. Should we support incremental updates to avoid reindexing everything?
