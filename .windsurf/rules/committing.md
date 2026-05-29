# Committing

When committing code changes, follow these procedures.

1. NEVER attempt to commit unless requested.

2. MUST follow these commit steps in series:
  a. Run `just loco-test` and `just demo-test` to ensure all tests pass.
  b. Run a `git status --porcelain` to see what files changed.
  c. MUST run `git add .` to stage all changes in the working directory and index.
     CRITICAL: Skipping this step will cause the commit to fail with "no changes added to commit".
  d. Run `git diff --staged` to see the changes of all staged files.
  e. Iterate over every modified file and generate a brief description of the
     changes for that file, including any relevant context or explanations.
  f. Compile all changes into a singular commit message utilizing Markdown
     headers, lists, and code blocks, ensuring that the message is clear and
     concise.
  g. Check the branch name to see if it has an issue number in it.
  h. Utilize a single-line message similar to `feat(Button): Add new feature`
     as the first line, providing a brief summary of the changes made.
  i. Commit the changes using local `git` with the `-m` flag and single quotes:
     `git commit -m 'commit message here'`. Do NOT use `git commit` without `-m`
     as this would open an interactive editor which is not suitable for automation.
     CRITICAL: Use simple single-quoted strings only. Do NOT use heredocs or
     complex shell constructs like `$(cat <<'EOF' ... EOF)` as these can
     cause the command to hang or fail.
  j. Push the changes to the remote repository using local `git` (NOT the
     GitHub MCP server), per `.windsurf/rules/github_operations.md`.
  k. Prompt the user if they are ready to create a pull request. If so, MUST
     follow `.windsurf/rules/creating_a_pull_request.md` in full (created via
     the GitHub MCP server).

3. MUST surround commit messages in single quotes so that we can use Markdown
   and backticks in the message, allowing for proper formatting and display.
