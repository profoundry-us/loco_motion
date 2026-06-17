---
name: create-issue
description: Investigates a problem, then writes and posts a well-structured
  GitHub issue. Use when the user says "create an issue", "open an issue",
  "file an issue", "report this bug", or "write a GitHub issue".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Create Issue

Investigates the problem, then composes and posts a GitHub issue with enough
detail for someone to pick it up cold.

## Instructions

### Step 1: Understand the problem

Gather the user's description of the problem. Identify:

- What is broken or missing?
- Which files, components, or docs are involved?
- What should the correct behavior look like?

If the user's description is vague, ask one clarifying question before
proceeding.

### Step 2: Investigate relevant files

Read the files that are directly relevant to the problem. The goal is to
understand the gap between what is documented/implemented and what is correct.

- **Documentation issues** — read the current docs AND a working reference
  (e.g. the demo app) to find every specific discrepancy.
- **Bug reports** — read the component class, template, and any related spec
  to understand the current (broken) behavior.
- **Feature requests** — read related components and the helpers registry
  to understand what already exists and what is missing.

Do not skip this step. A thorough issue requires knowing the actual state of
the code, not just what the user described.

### Step 3: Identify specific changes

From the investigation, produce a concrete list of what needs to change:

- Which files need to be updated?
- What exactly is wrong in each file?
- What should the correct content look like?
- Are there any reference files that show the correct pattern?

This list becomes the body of the issue.

### Step 4: Draft the issue

Structure the issue body as follows:

```markdown
## Problem

One paragraph describing what is wrong and why it matters to users.

## Specific Issues

### 1. {Descriptive heading for first gap}

Explain what is currently wrong, with code snippets if helpful.

### 2. {Descriptive heading for second gap}

...

## What to Update

- [ ] Actionable checkbox item
- [ ] Actionable checkbox item
- [ ] ...

## Reference

Point to any files or links that show the correct approach.
```

Do NOT hard-wrap the issue body at 80 characters — GitHub reflows it as prose.
Write natural paragraphs (one line each) and let them wrap on render. (Repo
Markdown files still wrap at 80; this exception is only for text posted to
GitHub.)

Keep the title short and imperative: "Update X for Y", "Fix Z in W".

### Step 5: Confirm with the user (optional)

For large or complex issues, show the user the draft title and body and ask
for approval before posting. For straightforward issues, proceed directly.

### Step 6: Post the issue

Create the issue using the GitHub MCP server's `create_issue` tool for
`profoundry-us/loco_motion`, passing the drafted title, body, and any labels.

Fall back to the `gh` CLI only if the MCP tool is unavailable or fails (for
example, a `403` permissions error):

```bash
gh issue create --title "{title}" --body "$(cat <<'EOF'
{body}
EOF
)"
```

Report the issue URL to the user.

## Examples

**Example 1 — documentation gap**

User: "The README install docs don't account for Tailwind 4."

1. Read `README.md` install sections.
2. Read the demo app CSS and `tailwind.config.js` to see the correct setup.
3. List every specific discrepancy (wrong command, wrong file, wrong version).
4. Create issue: "Update README install docs for Tailwind 4 and DaisyUI 5"

**Example 2 — component bug**

User: "The Skeleton component shows wrong colors."

1. Read `app/components/daisy/feedback/skeleton_component.rb` and its template.
2. Read the demo example and check DaisyUI 5 docs for the correct classes.
3. Note the specific wrong classes and what they should be.
4. Create issue: "Fix Skeleton component color classes for DaisyUI 5"

## Troubleshooting

**File not found** — Use `find` or `grep` to locate the relevant file. Do not
guess paths.

**Correct behavior unclear** — Check the demo app, DaisyUI docs, or ask the
user before writing the issue.

**User wants to start work immediately** — After posting the issue, offer to
run the `start-issue` skill with the new issue URL.
