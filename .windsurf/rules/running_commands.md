# Running Commands

When running commands, follow these procedures.

1.  Many Ruby-related commands (`bundle`, `rails`, `rspec`, etc.) MUST be run
    inside the appropriate Docker container using
    `docker compose exec -it <container_name> ` as a prefix.
    a. Use `loco` for tasks related to the LocoMotion library itself (e.g.,
       running library tests with `rspec`, managing library dependencies with
       `bundle`).
    b. Use `demo` for tasks related to the demo application (e.g., running demo
       app tests, accessing the demo Rails console).
    c. MUST determine the correct container (`loco` or `demo`) based on the
       command's purpose before proposing it.

2. NEVER change the Ruby version.

3. MUST review the Makefile to see if a relevant command already exists.

4. When removing a file with `rm` or moving a file with `mv`:
   a. MUST use `/bin/rm` or `/bin/mv` so that it doesn't prompt you for
   confirmation.

5. MUST run commands from the root of the project (which is the default).

6. NEVER use `cd` before running commands.

7. NEVER restart the demo app (`make demo-restart`) unless we make changes in
   the `lib/loco_motion` directory.
