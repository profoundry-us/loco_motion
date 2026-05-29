---
trigger: manual
---

# Creating a Pull Request

When asked to create a Pull Request (PR), follow these procedures:

0.  MUST follow the split defined in `.windsurf/rules/github_operations.md`:
    push the branch with local `git`, then create and label the PR using the
    GitHub MCP server. Only fall back to the `gh` CLI if an MCP tool is
    unavailable or fails (for example, a `403` permissions error).

1.  MUST ensure the branch is pushed to the remote with local `git` before
    creating the PR.

2.  MUST utilize the existing PR description template in `.github/pull_request_template.md`.

3.  MUST run `git log --oneline main..HEAD` to see a comprehensive list of all
    changes since branching from `main`.

4.  MUST format the PR description using Markdown.
  - include relevant lines based on the commit history in the PR description
  - Use the format `Fixes #123` for the Related Issue
  - Find the issue number contained in the current branch

5.  MUST present the PR description as a code snippet to the user for review and potential modification before proceeding.

6.  MUST update the `CHANGELOG.md`:
    a. Generate a concise summary of changes based on the commit messages in
       the current branch (similar to the PR description in Rule 6).
    b. Check if an `[Unreleased]` section exists at the top of the
       `CHANGELOG.md`.
    c. If it exists, add the generated summary list items under it.
    d. If it does not exist, create the `[Unreleased]` section header at the
       top and add the summary list items beneath it.

7.  MUST run `git add .` to add the `CHANGELOG.md` changes.

8.  MUST commit the `CHANGELOG.md` changes with the message
    `'docs: Update CHANGELOG'`, using single quotes.

9. MUST push the `CHANGELOG.md` commit to the remote repository using local
   `git`.

10. MUST create the pull request using the GitHub MCP server, then apply the
    appropriate labels via the MCP server.
