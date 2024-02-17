FROM timbru31/ruby-node:3.3-20

# Install some relevant dependencies
RUN apt-get update -qq && apt-get install -y tini build-essential git postgresql-client
RUN gem update --system

# Install the latest version of Rails
RUN gem install rails

# Run a simple command so that the container will stay running
ENTRYPOINT ["/usr/bin/tini", "--", "tail", "-f", "/dev/null"]
