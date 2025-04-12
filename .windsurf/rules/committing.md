# Committing

When committing code changes, follow these proceedures.

1. NEVER attempt to commit unless requested.

2. MUST follow these commit steps in series:
  a. If we are on the main branch, STOP and produce an error message.
  a. Run `make loco-test` to ensure all tests pass.
  b. Run a `git status --porcelain` to see what files changed.
  c. Run `git add .` to add all changed files to the index.
  d. Run `git diff` to see the changes of all modified files.
  e. Iterate over every modified file and generate a brief description of the
     changes for that file.
  f. Compile all changes into a singular commit message utilizing Markdown
     headers, lists, and code blocks.
  g. Utilize a single-line message similar to `feat(Button): Add new feature` as the first line.
  h. Commit the changes.
  i. Push the changes to the remote repository.
  j. If the push output contains `Create a pull request`, output a message to the
     user with a clickable link to the URL.
  k. Utilize the existing PR description template to output a description for this PR.
  l. Prompt for a PR URL
  m. Utilize the PR URL to add a line to the `Unreleased` section of the CHANGELOG.
  n. Run `git add .` to add the changes.
  o. Commit the code with a simple message about updating the CHANGELOG.
  p. Push the changes again.

2. MUST format links for Pull Requests as a clickable link.

4. MUST surround commmit messages in single quotes so that we can use Markdown
   and backticks in the message.
