#!/usr/bin/env sh

# Clear the Yard cache
rm -rf .yardoc

# Install any missing gems
bundle

# Run the Yard dev server and make it accessible outside of Docker (bind 0.0.0.0)
#
# Note that some options are defined in .yardopts because they can't be passed
# on the command line.
bundle exec yard server --reload --bind 0.0.0.0
