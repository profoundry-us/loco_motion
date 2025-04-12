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

2. MUST format links for Pull Requests as a clickable link.

4. MUST surround commmit messages in single quotes so that we can use Markdown
   and backticks in the message.
