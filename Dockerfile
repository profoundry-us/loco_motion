FROM ruby:3.2.3

# Install some relevant dependencies
RUN apt-get update -qq && apt-get install -y tini vim

ENV APP_HOME /home/loco_motion

WORKDIR $APP_HOME

COPY loco_motion.gemspec $APP_HOME/loco_motion.gemspec
COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install

# Add some aliases to our Bash shell for when we're messing around
RUN echo 'alias be="bundle exec"\nalias la="ls -al"' >> ~/.bashrc

# Run a simple command so that the container will stay running
ENTRYPOINT ["/usr/bin/tini", "--", "tail", "-f", "/dev/null"]
