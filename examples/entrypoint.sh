#!/bin/bash
set -e

# Run some standard rails checks / setup
bin/setup

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
