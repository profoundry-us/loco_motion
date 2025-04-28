# Committing

When committing code changes, follow these procedures.

1. NEVER attempt to commit unless requested.

2. MUST follow these commit steps in series:
  a. Run `make loco-test` and `make demo-test` to ensure all tests pass.
  b. Run a `git status --porcelain` to see what files changed.
  c. MUST run `git add .` to stage all changes in the working directory and index.
  d. Run `git diff --staged` to see the changes of all staged files.
  e. Iterate over every modified file and generate a brief description of the
     changes for that file, including any relevant context or explanations.
  f. Compile all changes into a singular commit message utilizing Markdown
     headers, lists, and code blocks, ensuring that the message is clear and
     concise.
  g. Check the branch name to see if it has an issue number in it.
  h. Utilize a single-line message similar to `feat(Button): Add new feature`
     as the first line, providing a brief summary of the changes made.
  i. Commit the changes.
  j. Push the changes to the remote repository.
  k. Prompt the user if they are ready to create a pull request.

3. MUST surround commit messages in single quotes so that we can use Markdown
   and backticks in the message, allowing for proper formatting and display.
