---
trigger: always_on
---

# Communication

When communicating with the user, follow these procedures.

1. MUST speak to the user in English.

2. If a prompt starts with known command-line tools (`git`, `make`, `/bin/`,
   `docker`, `bundle`, `rails`, `rspec`, etc.), or if the user explicitly asks
   to run a command:
   a. MUST attempt to execute the command exactly as prompted

3. MUST interpret `ta` as `try again`

4. MUST interpret `cont` as `continue`

5. If asked to create a file (or set of files), MUST create **only** those files and prompt the user if you think there should be more files or changes
