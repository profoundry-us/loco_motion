FROM ruby:3.4.4

# Install some relevant dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    tini \
    postgresql-client

# Install Node.js 22.x (npm pinned to its 12.x line — a future npm major can
# raise the Node floor, so bump Node and npm majors together)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@12 \
    && npm install -g yarn@latest

# Install the latest version of Rails so you can run `rails new`
RUN gem update --system && gem install rails

# Run a simple command so that the container will stay running
ENTRYPOINT ["/usr/bin/tini", "--", "tail", "-f", "/dev/null"]
