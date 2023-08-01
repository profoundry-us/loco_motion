# loco-motion
Modern tools to make Rails development crazy fast!

# Getting Started

We recommend using Docker to get your project setup from the beginning. Even
before you run the `rails new` command. This ensures that you have a stable
development environment, no matter what OS or system you're using to develop.

Look in the `examples` directory for a basic `docker-compose.yml` file to get
you started and give you a place to run commands.

Next, we recommend using a `Makefile` (also in `examples`) to create shortcuts
for running your various commands. `make` will run on just about any operating
system, and provides a self-documenting list of all of the ways that you
typically interact with your application. This means that other developers can
quickly see the common use-cases, but will also have a starting point if they
need to customize any of the commands for their particular setup.

Finally, we recommend VSCode as your editor, but this is purely preference. It
has a lot of plugins that make it really customizable, but utlimately, you
should use whatever editor makes you most comfortable during development.

You should now be able to run `make dev` to build and run all of the containers.

Once they have all built and started, in a separate terminal, you can run
`make dev-shell` to open a Bash shell into your development container.

Congratulations! You're ready to create your Rails app!

# Installing / Setting up Rails

Once you're inside of the development container, run `gem update --system` to
make sure you have the latest version of RubyGems.

Then, you can install the latest version of Rails inside of the container using
`gem install rails`.

Next `cd` into the `/home/app` directory which is mapped to your local machine.

In this directory, type `rails new . -d postgresql`.

Once complete, you should now be able to exit out of the dev container and kill
the running docker containers with `Ctrl-c` in the running terminal, or you can
open a new terminal and run `make down`.

Open the newly created `config/database.yml` file and add the following three
lines under the `default` key:

```yaml
  host: db
  username: postgres
  password: password
```

Now, uncomment the `app` section in your `docker-compose.yml` file and re-run
`make dev` to build the application.

Congratulations!

You can now visit (http://localhost:3000)[http://localhost:3000] in your web
browser and see your running Rails application!

# Next Steps

Install Rspec, Loco-Motion gems?, etc
