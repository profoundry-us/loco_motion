# GitHub Operations

When interacting with GitHub (issues, pull requests, labels, branches, CI
runs, commits, etc.), follow these procedures.

1. MUST prefer the GitHub MCP server tools over the `gh` CLI for all GitHub
   operations. The MCP tools are more reliable and do not hang waiting for
   interactive input.

2. MUST use the GitHub MCP server for the following common operations:
   a. Reading issues and comments (e.g. when starting an issue).
   b. Creating, reading, and updating pull requests.
   c. Listing and applying labels.
   d. Inspecting branches, commits, and CI / GitHub Actions runs and logs.

3. MUST use the MCP server's Actions tools to inspect CI status and pull
   failing logs when a pull request's checks fail, rather than asking the user
   to copy / paste errors.

4. The `gh` CLI MAY be used ONLY as a fallback when:
   a. An equivalent MCP tool does not exist, OR
   b. An MCP tool fails (for example, a write operation returns a `403`
      permissions error).

5. If a `gh` command appears to hang (for example, `gh pr create` waiting for
   interactive input), MUST cancel it and either provide all required
   arguments explicitly or switch to the MCP server.

6. If an MCP write operation fails with a `403` error, MUST inform the user
   that the GitHub MCP integration is missing write permissions, then fall
   back to the `gh` CLI to complete the operation.
