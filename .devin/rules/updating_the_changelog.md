# Updating the CHANGELOG

When modifying the `CHANGELOG.md` file, follow these procedures regarding format:

1. MUST review the existing `CHANGELOG.md` content to ensure consistency with
   the established format.

2. MUST ensure new entries are added as items to the bottom of the list under
   the correct section header (`[Unreleased]` or a specific version header like
   `## [X.Y.Z] - YYYY-MM-DD`).
    a. doc_note components and changes should always go under the "Demo / Docs
       Changes" section
    b. component changes should always go under the "Components Changes" section
    c. general changes should always go under the "General Changes" section

3. MUST maintain the link reference definitions at the bottom of the file when
   adding new version sections.

4. NEVER alter existing changelog entries unless explicitly asked.

5. MUST run `git status` and `git diff` to view ALL unstaged file changes in the
   repository and coalesce ALL changes.

6. MUST summarize all changes in a concise and clear manner, ensuring that
   each change is properly categorized and described.
