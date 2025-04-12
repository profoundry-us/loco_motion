# Creating a Pull Request

When asked to create a Pull Request (PR), follow these proceedures:

1.  MUST check the output of the last `git push`. If it contains `Create a pull request`, output a message to the user with a clickable link to that URL.

2.  MUST utilize the existing PR description template in `.github/pull_request_template.md`.

3.  MUST run `git log --oneline main..HEAD` to see a comprehensive list of all changes since branching from `main`.

4.  MUST include relevant lines based on the commit history in the PR description.

5.  MUST format the PR description using Markdown.

6.  MUST provide the generated description as a code snippet that the user can easily copy/paste into GitHub.

7.  MUST prompt the user for the URL of the created Pull Request.

8.  Once the user provides the PR URL, MUST utilize it to add a line to the `Unreleased` section of the `CHANGELOG.md`.

9.  MUST run `git add .` to add the `CHANGELOG.md` changes.

10. MUST commit the `CHANGELOG.md` changes with a simple message like `chore: Update CHANGELOG`.

11. MUST push the `CHANGELOG.md` commit to the remote repository.
