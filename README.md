# loco-motion

Modern paradigms and tools to make Rails development crazy fast!

<!-- toc -->

- [About](#about)
- [Getting Started](#getting-started)
- [Installing / Setting up Rails](#installing--setting-up-rails)
    + [Install HAML (Optional)](#install-haml-optional)
    + [Install DaisyUI (Optional)](#install-daisyui-optional)
    + [Try Out Your Application](#try-out-your-application)
- [Debugging](#debugging)
- [Testing](#testing)
- [Next Steps](#next-steps)

<!-- tocstop -->

# About

loco-motion is both a set of philosophies / paradigms for developing robust web
applications in Ruby on Rails, as well gems and tools to help you execute on
your vision quickly and reliably.

It includes standards for your

 * Development Environment
 * Testing / Debugging
 * CSS / Page Markup
 * Components / Libraries
 * Releasing / Hosting
 * and much more!

You can use as much or as little of the frameworks and philosophies provided,
and you can customize it all to your hearts content.

# Getting Started

We recommend using Docker to get your project setup from the beginning. Even
before you run the `rails new` command. This ensures that you have a stable
development environment, no matter what OS or system you're using to develop.

It also allows you to troubleshoot and debug the application since the
development container is so small and simple with very few dependencies.

You can download it from https://www.docker.com/.

Once you have that downloaded, open a terminal, and create a new directory for
your project. You can put it anywhere, but we recommend a directory structure
similar to the following:

```shell
mkdir -p ~/Development/mycompany/myproject
```

Now, change into that directory:

```shell
cd ~/Development/mycompany/myproject
```

Look in the `examples` directory for basic `docker-compose.yml`, `Dockerfile`,
`dev/Dockerfile`, and `entrypoint.sh` files to get you started and give you a
place to run commands. Copy these into your project directory.

Next, we recommend using a [Makefile](/blob/main/examples/Makefile) (also in
`examples`) to create shortcuts for running your various commands. `make` will
run on just about any operating system, and provides a self-documenting list of
all of the ways that you typically interact with your application. This means
that other developers can quickly see the common use-cases, but will also have a
starting point if they need to customize any of the commands for their
particular setup.

Copy this `Makefile` into your top-level project directory as well.

Your directory structure should look like this:

```txt
- ~/Development
  - mycompany
    - myproject
      - Dockerfile
      - Makefile
      - dev
        - Dockerfile
      - docker-compose.yml
      - entrypoint.sh
```

Finally, we recommend [VSCode](https://code.visualstudio.com/) as your code
editor, but this is purely preference. It has a lot of plugins that make it
really customizable, but utlimately, you should use whatever editor makes you
most comfortable during development.

You should now be able to run `make dev` in a terminal inside your project
directory to build and run all of the containers.

Once they have all built and started, in a separate terminal, you can run
`make dev-shell` to open a Bash shell into your development container.

Congratulations! You're ready to create your Rails app!

# Installing / Setting up Rails

Once you're inside of the development container, everything should be setup and
ready for you to install Ruby on Rails.

Change into the app directory which is mapped to your local machine and run the
`rails new` command:

> [!NOTE]
> If you want to use something other than PostgreSQL or TailwindCSS, you can
> change that here. These are just our recommendations.

```shell
cd /home/app && rails new . --skip --database=postgresql --javascript=esbuild --css=tailwind
```

Once complete, you should now be able to exit out of the dev container and kill
the running docker containers with <kbd>Ctrl-C</kbd> in the running terminal, or
you can open a new terminal and run `make down`.

Open the newly created `config/database.yml` file and add the following three
lines under the `default` key:

```yaml
  host: db
  username: postgres
  password: password
```

Now, uncomment the `app` section in your `docker-compose.yml` file and re-run
`make dev` to build the application.

After a minute or two, everything should be booted up and you should see output
similar to the following:

```txt
myproject-app-1    | == Restarting application server ==
myproject-app-1    | => Booting Puma
myproject-app-1    | => Rails 7.1.2 application starting in development
myproject-app-1    | => Run `bin/rails server --help` for more startup options
myproject-app-1    | Puma starting in single mode...
myproject-app-1    | * Puma version: 6.4.0 (ruby 3.3.0-p-1) ("The Eagle of Durango")
myproject-app-1    | *  Min threads: 5
myproject-app-1    | *  Max threads: 5
myproject-app-1    | *  Environment: development
myproject-app-1    | *          PID: 1
myproject-app-1    | * Listening on http://0.0.0.0:3000
myproject-app-1    | Use Ctrl-C to stop
```

Congratulations!

You can now visit [http://localhost:3000](http://localhost:3000) in your web
browser and see your running Rails application!

### Install HAML (Optional)

While you can use the default ERB templating system that comes with Rails, we
highly recommend using HAML instead as it provides a much cleaner language for
your template files.

Drop this at the bottom of your `Gemfile`:

> [!NOTE]
> We suggest keeping your custom gems alphabetized at the bottom.

```yaml
# App-Specific Gems
gem "haml-rails", "~> 2.0"
```

And add the following to your `Gemfile` in the `group :development` section:

```yaml
gem 'html2haml'
```

Next, open up a Docker shell in the app container using `make app-shell` and
run `bundle` to install the HAML gem.

Next, open up your `tailwind.config.js` file and replace the line for `erb`
views with `haml` views:

```js
module.exports = {
  content: [
    './app/views/**/*.html.haml',
    // ...
  ]
```

Finally, you can run the following command to replace all of your `.erb`
files with `.haml` versions:

```bash
HAML_RAILS_DELETE_ERB=true rails haml:erb2haml
```

You should see output similar to the following:

```text
--------------------------------------------------------------------------------
Generating HAML for app/views/layouts/application.html.erb...
Generating HAML for app/views/layouts/mailer.html.erb...
Generating HAML for app/views/layouts/mailer.text.erb...
--------------------------------------------------------------------------------
HAML generated for the following files:
        app/views/layouts/application.html.erb
        app/views/layouts/mailer.html.erb
        app/views/layouts/mailer.text.erb
--------------------------------------------------------------------------------
Deleting original .erb files.
--------------------------------------------------------------------------------
Task complete!
```

### Install DaisyUI (Optional)

Next up, let's utilize a mighty combo for our CSS layer!

[TailwindCSS](https://tailwindcss.com/) is a utility-based CSS framework which
allows you to easily build your own components by piecing together the utility
classes that you need.

For example, to make a rounded button, you might do something like this:

```haml
%button.px-4.py-2.border.rounded-lg
  My Button
```

> [!IMPORTANT]
> We _highly_ recommend using Tailwind for every project and have already
> installed it as part of the `rails new` command above.

[DaisyUI](https://daisyui.com/) takes a more traditional route and provides a
set of classes that utilize Tailwind to create the components for you. This
means your button above would look more like this:

```haml
%button.btn
  My Button
```

If you want pure customization or are building your own UI components from
scratch, we recommend that you stick with Tailwind by itself.

However, if you're working on a project and want a good starting point for UI
components, you might checkout DaisyUI or a simliar Tailwind-based UI library.

DaisyUI is a plugin for Tailwind, so installing it is dead simple. Just open up
an app shell by running `make app-shell` in the terminal and run the following
command:

```shell
yarn add daisyui@latest --dev
```

Next, edit your `tailwind.config.js` file to add it as a plugin:

> [!IMPORTANT]
> Make sure to add a `,` to the previous line if you put it at the bottom.

```js
module.exports = {
  //...
  plugins: [require("daisyui")],
}
```

### Try Out Your Application

Now that we have everything installed and running, let's build a few simple
parts of a Rails application to test that everything is working properly!

Open up your `Procfile.dev` and tell the Rails server to bind to `0.0.0.0`:

```
web: env RUBY_DEBUG_OPEN=true bin/rails server -b 0.0.0.0
```

Next, you'll need to update the `Dockerfile` to tell Docker how to start
your app using Foreman.

Change the following line:

```Dockerfile
CMD ["rails", "server", "-b", "0.0.0.0"]
```

to

```Dockerfile
CMD ["./bin/dev"]
```

Since we're using Docker, you might also want to edit your `bin/dev` file (or
alternatively the `bin/setup` file) to automatically remove any old PID files
that might be lying around from a bad container shutdown.

Add the following lines right above the last line (`exec foreman start ...`):

```sh
# Delete any old PID files
rm /home/app/tmp/pids/server.pid
```

Finally, you can kill your running docker containers (either using
<kbd>Ctrl-C</kbd>, opening a new terminal in your project folder and running
`make down`, or using the Docker UI to stop all of the containers).

Now restart using `make dev`.

> [!TIP]
> Once you have stabalized your Dockerfile and any dependencies, you can run
> `make dev-quick` to launch the containers without rebuilding.
>
> In this case, since we changed our `Dockerfile`, we still need to use the
> regular `make dev` command.

You should be able to test that everything is working by altering a few files so
you can see some custom output:

```ruby
# config/routes.rb

root "application#test"
```

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  def test
    render html: 'Test', layout: true
  end
end
```

```haml
# app/views/layouts/application.html.haml

  # Just modify the body & yield lines to look like this

  %body
    .m-2.p-2.rounded.bg-red-400
      = yield
```

Now visit [http://localhost:3000](http://localhost:3000) and you should
see a red, rounded box with the word "Test"!

If you also installed, DaisyUI, we can test that as well. Add some additional
code to the bottom of the `application.html.haml` file:

```haml
# app/views/layouts/application.html.haml

  # Leave the html / head code above

  %body
    .m-2.p-2.rounded.bg-red-400
      = yield

    # Add this
    .btn
      Test Button
```

If everything worked, you should see a gray button that changes when
you hover and click on it!

# Debugging

The latest version of Rails makes it much easier to debug within a Docker
container as it automatically starts a remote debugger for you.

Add the word `debugger` anywhere in your code (perhaps the `test` method of you
`ApplicationController`), reload the page (it will look like it's hanging), and
then run `make app-debug` in a separate terminal.

This will connect to the remote debugger instance which will be stopped at your
`debugger` line.

# Testing

Before we start creating a bunch of models, controllers, and other pieces of
code, it's good to get a solid testing foundation in place. Rails ships with
[MiniTest](https://guides.rubyonrails.org/testing.html) out of the box and many
people prefer this as it's built-in and is essentially just Ruby code.

However, many larger teams opt to utilize [RSpec](https://rspec.info/) which is
a Behavior Driven Development (BDD) framework whose tests utilize the english
language to help you build relevant test cases. It also has a large ecosystem of
plugins which can accelerate your development.

Which one you choose is up to you, but after developing many applications, we
recommned Rspec with (factory_bot)[https://github.com/thoughtbot/factory_bot]
and (Shoulda Matchers)[https://github.com/thoughtbot/shoulda-matchers].

Finally, although both libraries offer some functionality for testing your user
interface, we recommend utilizing (Cypress)[https://www.cypress.io/] instead as
it more closely mimics the real user experience in a browser and it allows you
to see in real-time what is happening, including in-browser debugging!

One thing to note about Cypress, however, is that it is Javascript-based and
thus requires you to write tests in Javascript. If you are only famililar with
Ruby, you might want to stick with Rspec or Minitest when you first start your
project, and expand into using Cypress once you are comfortable learning a new
lanugage / framework.

# Next Steps

TODO: loco-motion / Daisy-rails gems?, etc
