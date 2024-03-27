<!-- omit from toc -->
# Contributing

This is the ADR contributing guide!

<!-- toc -->
- [Getting Started](#getting-started)
- [TODO](#todo)
<!-- tocstop -->

## Getting Started

Not much to put here yet, but want to remember that we use the VSCode plugin
[Markdown All In One][1] for keeping our Table of Contents up-to-date in any
markdown files (like the `README.md` or this one).

> [!CAUTION]
> You MUST generate a ToC first or it won't even attempt to auto update it. The
> plugin also appears to be a bit finicky and requires at least a few headings
> in order to auto-update on save.

Also, note that we generally don't put the title heading in the table of
contents as it feel repetitive and unnecessary. And we typically use H2 (`##`)
headings for every "top-level" heading after the title. This is mainly
preference due to the massive size of the H1 headings.

## TODO

- [ ] Discuss how to alter the templates
  * Copy the file and rename
  * Remove the quotes
  * Where should you generally start / order of filling out

- [ ] Discuss the process for submitting an ADR
  * Push a draft PR for collaboration
  * When ready, change status, check off relevant ADR tasks, submit real PR
  * Make any necessary changes until approved / rejected

- [ ] How do we handle rejections?
  * Just add REJECTED to the title?
  * Move them to sub-folder?
  * Can rejected ones be reopened later?

- [ ] Cleanup / organize thoughts better

- [ ] Investigate whether or not we need the `toc` / `tocstop` comments since
      they aren't auto-generated

[1]: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
