# Running Commands

When running commands, follow these proceedures.

1. MUST run Ruby-related commands through Docker.

2. NEVER change the Ruby version.

3. MUST review the Makefile to see if a relevant command already exists.

4. When removing a file with `rm` or moving a file with `mv`:
   a. MUST use `/bin/rm` or `/bin/mv` so that it doesn't prompt you for confirmation.

5. MUST run commands from the root of the project (which is the default).

6. NEVER use `cd` before running commands.

7. NEVER restart the demo app (`make demo-restart`) unless we make changes in
   the `lib/loco_motion` directory.
