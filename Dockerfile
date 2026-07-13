FROM ruby:3.4.4

# Update and install basic dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    tini \
    vim \
    gnupg

# Install Node.js 22.x (npm pinned to its 12.x line — a future npm major can
# raise the Node floor, so bump Node and npm majors together)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@12 \
    && npm install -g yarn@latest \
    && yarn

ENV APP_HOME /home/loco_motion

WORKDIR $APP_HOME

COPY loco_motion-rails.gemspec $APP_HOME/loco_motion-rails.gemspec
COPY Gemfile Gemfile* $APP_HOME
COPY lib/loco_motion/version.rb $APP_HOME/lib/loco_motion/
RUN bundle install

# Add some aliases to our Bash shell for when we're messing around
RUN echo 'alias be="bundle exec"\nalias la="ls -al"' >> ~/.bashrc

# Run a simple command so that the container will stay running
ENTRYPOINT ["/usr/bin/tini", "--", "tail", "-f", "/dev/null"]
