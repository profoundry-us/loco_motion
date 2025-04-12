# Creating a Pull Request

When asked to create a Pull Request (PR), follow these procedures:

1.  MUST check the output of the last `git push`. If it contains
    `Create a pull request`, output a message to the user with a clickable link
    to that URL.

2.  MUST utilize the existing PR description template in `.github/pull_request_template.md`.

3.  MUST run `git log --oneline main..HEAD` to see a comprehensive list of all
    changes since branching from `main`.

4.  MUST include relevant lines based on the commit history in the PR
    description.

5.  MUST format the PR description using Markdown.

6.  MUST present the PR description as a code snippet to the user for review and
potential modification before proceeding.

7.  MUST update the `CHANGELOG.md`:
    a. Generate a concise summary of changes based on the commit messages in
       the current branch (similar to the PR description in Rule 6).
    b. Check if an `[Unreleased]` section exists at the top of the
       `CHANGELOG.md`.
    c. If it exists, add the generated summary list items under it.
    d. If it does not exist, create the `[Unreleased]` section header at the
       top and add the summary list items beneath it.

8.  MUST run `git add .` to add the `CHANGELOG.md` changes.

9.  MUST commit the `CHANGELOG.md` changes with the message
    `'docs: Update CHANGELOG'`, using single quotes.

10. MUST push the `CHANGELOG.md` commit to the remote repository.
