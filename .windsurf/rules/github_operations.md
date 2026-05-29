# GitHub Operations

When interacting with GitHub, MUST split responsibilities between local `git`
commands and the GitHub MCP server as follows.

## Local git (use the terminal)

1. MUST use local `git` commands for all repository / source-control
   operations, including:
   a. Creating, switching, and deleting branches.
   b. Staging and committing changes.
   c. Pushing commits to the remote.
   d. Fetching, pulling, rebasing, and merging.

2. MUST NOT use the GitHub MCP server to push code or create commits (e.g.
   avoid `push_files`); committing and pushing happen through local `git`.

## GitHub MCP server (use the MCP tools)

3. MUST use the GitHub MCP server for GitHub-platform operations layered on top
   of those branches and commits, including:
   a. Creating, reading, and updating issues (and issue comments).
   b. Creating, reading, and updating pull requests.
   c. Listing and applying labels.
   d. Inspecting CI / GitHub Actions runs and pulling failing logs.

4. MUST use the MCP server's Actions tools to inspect CI status and pull
   failing logs when a pull request's checks fail, rather than asking the user
   to copy / paste errors.

5. Before creating a pull request via the MCP server, MUST ensure the branch
   has already been pushed to the remote with local `git`.

## Fallbacks

6. The `gh` CLI MAY be used ONLY as a fallback when an equivalent MCP tool does
   not exist or fails (for example, a write operation returns a `403`
   permissions error).

7. If a `gh` command appears to hang (for example, `gh pr create` waiting for
   interactive input), MUST cancel it and either provide all required
   arguments explicitly or switch to the MCP server.

8. If an MCP write operation fails with a `403` error, MUST inform the user
   that the GitHub MCP integration is missing write permissions (the token may
   be read-only), then fall back to the `gh` CLI to complete the operation.
