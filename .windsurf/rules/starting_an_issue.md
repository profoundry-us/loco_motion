# Starting an Issue

When asked to being work on a new GitHub issue, MUST follow these steps.

1. MUST read the issue using the GitHub MCP server (per
   `.windsurf/rules/github_operations.md`), falling back to visiting the
   provided URL only if the MCP server is unavailable
2. MUST read the issue description and comments
3. MUST craft a relevant branch name using all of the following:
  a. The issue type (bug, feat, task, etc)
  b. The issue number
  c. A shortened version of the issue title
  examples: bug-123-add-foo-component, feat-456-improve-bar-component
4. MUST prompt the user to create a new branch using the crafted branch name,
   creating it with local `git` (per `.windsurf/rules/github_operations.md`)
5. MUST prompt the user to ask if they want to create a plan
   a. If no, MUST stop
   b. If yes, MUST begin process outlined in `.windsurf/rules/creating_a_plan.md`
