# Releasing

When initiating the release process, follow these steps sequentially AFTER
confirming all changes are merged to `main` and the local `main` branch is
up-to-date:

1.  MUST verify being on the `main` branch. If not, STOP and instruct the user
    to switch to `main` and pull the latest changes.

2.  MUST **propose updating the release version**:
    a. Prompt the user for the specific new semantic version number (e.g.,
       `1.2.3`).
    b. Once the version is provided, propose running the command
       `make version-set NEW_VERSION=<user_provided_version>`.
    c. After the `version-set` command succeeds, propose running the command
       `make version-lock`.

3.  MUST **propose building the packages**:
    a. Propose running the command `make gem-build`.
    b. Propose running the command `make npm-build`.
    c. After builds succeed, inform the user to manually verify the contents of
       the built packages in `builds/rubygems` and `builds/npm`.

4.  MUST **propose finalizing the CHANGELOG** for the release version:
    a. Prompt the user to confirm the version number being released (this
       should match the version from step 2a).
    b. Obtain the current date in `YYYY-MM-DD` format.
    c. Propose editing `CHANGELOG.md` to replace the `[Unreleased]` header line
       with the new version header: `## [<version>] - <date>` (e.g.,
       `## [1.2.3] - 2025-04-12`).
    d. Propose staging the `CHANGELOG.md` changes using `git add CHANGELOG.md`.
    e. Propose committing the changes using the message
       `'docs: Finalize CHANGELOG for release v<version>'`, replacing
       `<version>`. Use single quotes.
    f. Propose pushing the commit using `git push`.

5.  MUST **propose tagging the release**:
    a. Determine the current version using `make version` (let this be
       `<current_version>`).
    b. Propose running the command `git tag v<current_version>`.
    c. Propose running the command `git push origin v<current_version>`.

6.  MUST **propose publishing the packages**:
    a. Propose running the command `make gem-publish`.
    b. Propose running the command `make npm-publish`.
    c. MUST remind the user that these steps require external
       credentials/authentication and should be run with caution.

7.  MUST inform the user that the automated parts of the release process are
    complete and that they should now proceed with the manual steps outlined
    in the project's releasing guide, such as creating the GitHub release via
    the UI.
