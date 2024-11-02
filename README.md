<!-- omit from toc -->
# loco_motion

Crazy fast Rails development with modern tools and components leveraging
ViewComponent, TailwindCSS, DaisyUI and more!

<img src="//loco-motion-docs.profoundry.us/images/loco-chats.png" width="500px" style="border: 1px solid #bbb; padding: 2px; border-radius: 10px;">

_**DISCLAIMER**_

This project is in active development and many changes occur with every release!
In particular, new Daisy components are being added frequently and older
components are being updated with new features meaning the APIs are very likely
to change!

We plan to publish the docs site to a publicly available URL soon, but until
then, you can run the docs by cloning the repository and running `make all` (or
`make all-quick` if you've already run `make all` or `make rebuild` previously)
and visiting http://localhost:3000/ in your browser.

Please reach out by opening an
[Issue](https://github.com/profoundry-us/loco_motion/issues) if you've found a
bug or starting a
[Discussion](https://github.com/profoundry-us/loco_motion/discussions) if you
have a question!

Please open a Discussion / Issue **before** starting a Pull Request to make sure
we aren't already working on the suggested feature / bug, and to ensure that
your solution is aligned with our goals.

- [About](#about)
- [Getting Started](#getting-started)
- [Installing / Setting up Rails](#installing--setting-up-rails)
  - [Install HAML (Optional)](#install-haml-optional)
  - [Install DaisyUI (Optional)](#install-daisyui-optional)
  - [Try Out Your Application](#try-out-your-application)
- [Debugging](#debugging)
- [Testing](#testing)
- [Authentication](#authentication)
- [Web Console](#web-console)
- [BetterErrors (Optional)](#bettererrors-optional)
- [LocoMotion Components](#locomotion-components)
  - [Install](#install)
  - [Using Components](#using-components)
  - [Setting a Base Component Class](#setting-a-base-component-class)
- [Developing](#developing)
  - [Tooling](#tooling)
- [TODO / Next Steps](#todo--next-steps)


## About

loco_motion is both a set of philosophies and paradigms for developing robust
web applications in Ruby on Rails, as well gems and tools to help you execute
on your vision quickly and reliably.

It includes standards for your

 * Development Environment
 * Testing / Debugging
 * CSS / Page Markup
 * Components / Libraries
 * Releasing / Hosting
 * and much more!

You can use as much or as little of the frameworks and philosophies provided,
and you can customize it all to your heart's content.

## Getting Started

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

Next, we recommend using a [Makefile](/examples/Makefile) (also in
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

## Installing / Setting up Rails

Once you're inside of the development container, everything should be setup and
ready for you to install Ruby on Rails.

Change into the app directory which is mapped to your local machine and run the
`rails new` command:

> [!NOTE]
> If you want to use something other than PostgreSQL or TailwindCSS, you can
> change that here. These are just our recommendations.

> [!TIP]
> We tend to recommend that you lag behind on the latest version of Ruby as
> it can occassionally have issues building the Rails project. But you can
> swap it to the latest inside of the `dev/Dockerfile` by changing the `FROM`
> line at the top.

```shell
cd /home/app && rails new . --skip --database=postgresql --javascript=esbuild --css=tailwind
```

If you run into trouble with the above Rails command, this should get you back
to a good starting point without having to blow away any changes you might have
made to the dev files.

```shell
rm -rf .dockerignore .git .gitattributes .gitignore .node-version .ruby-version\
  Gemfile README.md Rakefile app bin config config.ru
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

Now, uncomment the `app` section in your `docker-compose.yml` file and run
`make app` to build the application.

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
highly recommend using [HAML](https://haml.info/) instead as it provides a much
cleaner language for your template files.

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

> [!IMPORTANT]
> Moving forward, this guide will assume you have installed DaisyUI, so some of
> the example view files will utilize these CSS classes.

### Try Out Your Application

Now that we have everything installed and running, let's build a few simple
parts of a Rails application to test that everything is working properly!

By default, only the Rails application is running, but we now need to build
and bundle our Javascript and CSS.

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

Since we're using Docker, you might also want to edit your `bin/setup` file
to automatically remove any old PID files that might be lying around from a bad
container shutdown.

Add the following lines right above the last few lines that restart the
application server:

```sh
puts "\n== Removing old PID files =="
system! "rm -rf /home/app/tmp/pids/server.pid"
```

Finally, you can kill your running docker containers (either using
<kbd>Ctrl-C</kbd>, opening a new terminal in your project folder and running
`make down`, or using the Docker UI to stop all of the containers).

Now restart using `make app`.

> [!TIP]
> Once you have stabalized your Dockerfile and any dependencies, you can run
> `make app-quick` to launch the containers without rebuilding.
>
> In this case, since we changed our `Dockerfile`, we still need to use the
> regular `make app` command.

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

> [!CAUTION]
> Once you're done playing around with this, you should undo your changes to the
> layout so that it doesn't cause confusion in later parts of this guide.

## Debugging

The latest version of Rails makes it much easier to debug within a Docker
container as it automatically starts a remote debugger for you.

Add the word `debugger` anywhere in your code (perhaps the `test` method of your
`ApplicationController`), reload the page (it will look like it's hanging), and
then run `make app-debug` in a separate terminal.

This will connect to the remote debugger instance which will be stopped at your
`debugger` line.

## Testing

Before we start creating a bunch of models, controllers, and other pieces of
code, it's good to get a solid testing foundation in place. Rails ships with
[MiniTest](https://guides.rubyonrails.org/testing.html) out of the box and many
people prefer this as it's built-in and is essentially just Ruby code.

However, many larger teams opt to utilize [RSpec](https://rspec.info/) which is
a Behavior Driven Development (BDD) framework whose tests utilize the english
language to help you build relevant test cases. It also has a large ecosystem of
plugins which can accelerate your development.

Which one you choose is up to you, but after developing many applications, we
recommned Rspec with [factory_bot](https://github.com/thoughtbot/factory_bot)
and [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers).

Finally, although both libraries offer some functionality for testing your user
interface, we recommend utilizing [Cypress](https://www.cypress.io/) instead as
it more closely mimics the real user experience in a browser and it allows you
to see in real-time what is happening, including in-browser debugging!

> [!NOTE]
> One thing to note about Cypress, however, is that it is Javascript-based and
> thus requires you to write tests in Javascript. If you are only famililar with
> Ruby, you might want to stick with Rspec or Minitest when you first start your
> project, and expand into using Cypress once you are comfortable learning a new
> lanugage / framework.

## Authentication

There are a **lot** of different ways to handle user authentication in Ruby on
Rails. Because of this, many gems have popped up to help you handle this. The
two most popular ones are [OmniAuth](https://github.com/omniauth/omniauth) and
[Devise](https://github.com/heartcombo/devise).

We recommend starting with OmniAuth because it has a very simple `:developer`
authentication strategy which will allow you to get started very quickly, and
it allows you to
[integrate with devise](https://github.com/heartcombo/devise#omniauth) or a
service like [Auth0](https://auth0.com/) later if you choose.

> [!TIP]
> You can always find the latest setup documentation on OmniAuth's README.

Add the relevant gems to your application's `Gemfile` and re-run
`bundle install`:

```Gemfile
gem 'omniauth'
gem "omniauth-rails_csrf_protection"
```

After that has finished, you'll need to restart your Rails server.

> [!TIP]
> Although you can do this by using <kbd>Ctrl-C</kbd> and re-running `make
> app-quick`, a faster way to restart only the web server is to create a
> temporary file named `restart.txt`.
>
> You can easily do this by running `touch tmp/restart.txt` in a terminal!

Next, create an OmniAuth initializer:

```ruby
# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
end
```

We'll need to setup a few routes:

```ruby
# config/routes.rb

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
```

Finally, we'll need to add the relevant sessions controller and view:

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
    raise user_info # Your own session management should be placed here.

    session[:user_info] = user_info.to_hash

    redirect_to root_path
  end
end
```

```haml
=# app/views/sessions/new.html.haml

- if Rails.env.development?
  = form_tag('/auth/developer', method: 'post', data: {turbo: false}) do
    %button.btn{ type: 'submit' }
      Login with Developer
```

From here, you can login by visiting http://localhost:3000/login, clicking the
button, and entering a random name and email address.

It should throw an error and show you the line that it failed on
(`raise user_info`).

This is not terribly helpful as you can't easily inspect the variable and see
it's value.

In general, you'd want to set this to something like `session[:user_info]` and
integrate it into your application flow.

When you're ready for it to work, just delete or comment out the
`raise user_info` line.

However, this gives us an opportune time to get some better error management.
So let's do that first!

## Web Console

At this point, if you look in your Docker logs, you'll probably see a line like
the following:

```text
Cannot render console from 172.23.0.1! Allowed networks: 127.0.0.0/127.255.255.255, ::1
```

> [!NOTE]
> Your IP address may be different! Take note of what IP the error says.

Because we're running inside Docker, we have a different network than what Rails
typically expects (127.0.0.1) and it blocks the default web console that loads
when an error happens.

This is easy to fix, we just need to take the IP address in the error message
above and add the following line to our `config/environments/development.rb`
file:

```ruby
# Fix console permissions for Docker
config.web_console.permissions = '172.23.0.1'
```

Restart the application and refresh the page. You should see the same error
appear, but now, you should see a black console at the bottom of the screen that
allows you to interact with the application.

Type the following in the console and hit enter:

```ruby
user_info.to_hash
```

You should see some information about the user you just logged in with.

You can run pretty much any code in this console that you would run inside your
controllers, views, models, etc.

In fact, when I'm debugging an issue, I often find a point just above where I'm
wanting to look, type something non-existant like `asdf` in my Rails code, and
then refresh the page.

This will stop the application where the `asdf` was found and allows you to
interact with your application and see exactly what's going on.

## BetterErrors (Optional)

[BetterErrors](https://github.com/BetterErrors/better_errors) provides (in our
humble opinion) a slightly better interface for the errors that sometimes happen
in a Rails application.

In particular, we like how it lays out the stack trace to the left of the code
and console and adds a bit more styling to the page to make it easier to read.

It's also very easy to install!

Add the following to your `Gemfile` and re-run `bundle install` inside of the
Docker app container (`make app-shell`).

> [!TIP]
> You can also just kill (using <kbd>Ctrl-C</kbd>) and restart the container
> using `make app-quick` as this process attempts to install any gems for you.


```Gemfile
# Gemfile

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end
```

> [!IMPORTANT]
> It is imperitive that you put these in the `:development` tag so that they
> cannot load in production.
>
> This would lead to a **massive** security risk!

Again, because we're running inside of Docker, we'll need to tell BetterErrors
that it's allowed to render for our IP address.

Add the following to the `config/environments/development.rb` file (make sure
the IP address matches the one you used for the Web Console above):

```ruby
# Allow BetterErrors to render
BetterErrors::Middleware.allow_ip! '172.23.0.1'
```

## LocoMotion Components

In addition to the recommendations / suggestions above, LocoMotion also provides
a full set of UI components to help you build robust and full-featured apps.

> [!CAUTION]
> The LocoMotion components are being actively developed and are NOT ready for
> production / public use! We have finished basic versions of the DaisyUI
> Actions, DataDisplay, and Navigation components, but we expect these to change
> (possibly quite a bit) as we begin to use them in projects.

### Install

Add the following to your `Gemfile` and re-run `bundle`:

```Gemfile
# Gemfile

gem "loco_motion", github: "profoundry-us/loco_motion", branch: "main", require: "loco_motion"

# or

gem "loco_motion-rails", "0.0.6", require: "loco_motion"
```

Next add the following lines to the `contents` section of your
`tailwind.config.js` to import / build the proper files:

```js
  const { execSync } = require('child_process');

  let locoBundlePath = execSync('bundle show loco_motion').toString().trim();

  module.exports = {
    content:[
      `${locoBundlePath}/app/components/**/*.{rb,js,html.haml}`,

      // ...
    ]
  }
```

> [!WARNING]
> Note that this will not output anything if it fails to find the right
> directory, so your CSS may not compile properly if this command fails or finds
> the wrong gem or an older gem.

Next, if you're using any of the components that require JavaScript (like the
Countdown component), you'll need to add the library as a dependency and include
those controllers in your `application.js` file.

```sh
npm add @profoundry-us/loco_motion
```

or

```sh
yarn add @profoundry-us/loco_motion
```

Then inside your `application.js` file, make sure to import and register the
relevant controllers.

```js
import { Application } from "@hotwired/stimulus"

import { CountdownController } from "@profoundry-us/loco_motion"

const application = Application.start()

application.register("countdown", CountdownController)

export { application }
```

### Using Components

Back in the `app/layouts/application.html.haml` file, replace the `body` with
the following code and refresh your page.

```haml
  %body
    .m-2.p-2.rounded.bg-red-400
      = session[:user_info].inspect

    %div
      = render(Daisy::Actions::ButtonComponent.new(title: "Click Me"))

    %div
      = daisy_button(css: "btn-primary") do
        Click Me Too

    = yield
```

You should see a few buttons and the user info that we saved from OmniAuth
represented as a Ruby hash! Any other content you have will be rendered below.

### Setting a Base Component Class

Sometimes, you may want to override the way that LocoMotion handles things, or
provide some functionality yourself in a sub-class of our components. Since you
can't have a class inherit from two classes, we give you a way to override the
base class that all of our components inherit from.

This allows you to define a class that inherits from `LocoMotion::BaseComponent`
and then adds any special methods or overrides to our default components.

Create a file called `app/components/application_component.rb` with the following
contents:

```ruby
class ApplicationComponent < LocoMotion::BaseComponent
end
```

Then add the following to `config/initializers/loco_motion.rb`.


```ruby
LocoMotion.configure do |config|

  # Override the base component class to inherit from our ApplicationComponent
  # so that we can add our own overrides / methods.
  Rails.application.config.after_initialize do
    config.base_component_class = ApplicationComponent
  end

end
```

> [!NOTE]
> It doesn't have to inherit from `ApplicationComponent`, you can use any class
> you want, so you could create a separate `CustomizedLocoMotionComponent` class
> so that you don't have any conflicts with your `ApplicationComponent`.

## Developing

To work on LocoMotion, first clone the repository and make sure you have Docker
installed and running on your machine.

Next, create a `.env.local` file with the following contents, making sure to
replace the Unsplash keys with real ones (you can create your own account or ask
Topher for his keys).

```.env
# .env.local
UNSPLASH_ACCESS_KEY="<< INSERT ACCESS KEY >>"
UNSPLASH_SECRET_KEY="<< INSERT SECRET KEY >>"
```

You should then be able to run `make rebuild` in the project directory and then
`make all-quick` to start the services.

> [!NOTE]
>
> We use `yarn link` and `bundle config local.loco_motion-rails` within the
> `docs/demo/bin/setup` script to enable quick editing of the library files so
> you don't have to publish new packages during testing.

From here, you can access the demo site at http://localhost:3000 and the YARD
docs at http://localhost:8808/docs/yard

You can type `make demo-shell` to open a shell inside the demo Docker container,
or `make loco-shell` to get a shell inside the gem's Docker container.

See the `Makefile` for all available commands.

> [!WARNING]
>
> Right now, Rails doesn't auto-reload the LocoMotion library files when they
> change, so you might have to restart your server to get it to pickup the
> changes.
>
> ```sh
> make demo-restart
> ```


The last commit of your PR should be to run `make demo-shell` and then
`bundle update loco_motion-rails` to ensure that the live site will use the
latest version of LocoMotion which includes your changes. You should also
thoroughly test the demo site after making this change.

### Tooling

For VSCode, you may want to add the following to your settings to get
TailwindCSS Intellisense working properly.

```json
  "tailwindCSS.emmetCompletions": true,
  "tailwindCSS.includeLanguages": {
    "haml": "html",
    "ruby": "html",
  },
  "files.associations": {
    "*.html.haml": "haml"
  },
  "tailwindCSS.experimental.classRegex": [
    [ "add_css\\(:[a-z]+, ?\"([^\"]*)\"", "([a-zA-Z0-9\\-:]+)" ],
    [ "css: ?\"([^\"]*)\"", "([a-zA-Z0-9\\-:]+)" ],
    [ "class: ?\"([^\"]*)\"", "([a-zA-Z0-9\\-:]+)" ],
    [ "(\\.[\\w\\-.]+)[\\n\\=\\{\\s]", "([\\w\\-]+)" ],
  ],
```

And because whitespace is important when developing inline components, you
should also add the following which prevents VSCode from adding a newline to the
bottom of your HAML files. This helps ensure that inline components don't have
trailing whitespace when using something like the `succeed` helper.

```json
  "[haml]": {
      "editor.formatOnSave": false
  }
```

Alternatively, if your component is simple enough, moving the template inside
the `_component.rb` file's `call` method can also alleviate this problem.

So instead of

```haml
- # This file has a newline at the bottom which can cause problems
= part(:component) do
  = content

```

you could do something like this:

```ruby
def call
  part(:component) { content }
end
```

## TODO / Next Steps

There is a LOT left to be done. We're not currently seeking assistance, but if
you feel very strongly that you'd like to contribute, please reach out through
the GitHub Discussions feature and let us know!

- [x] Basic versions of DaisyUI Actions
- [x] Basic versions of DaisyUI Data Display
- [x] Basic versions of DaisyUI Navigation
- [ ] Basic versions of DaisyUI Feedback
- [ ] Basic versions of DaisyUI Data Input
- [ ] Basic versions of DaisyUI Layout
- [ ] Basic versions of DaisyUI Mockup
- [ ] Get YARD docs rendering with (better) Markdown
- [x] Extract relevant pieces into a yard-loco_motion plugin
- [x] Publish Gem
- [x] Publish NPM package
- [ ] Update YARD plugin to add `@part`s
- [x] Extract doc callouts into a doc component (and / or the Daisy component)
- [ ] Choose and recommend / document a pagination gem
- [ ] Discuss caching techniques / setup
- [ ] Create / publish a production version of the demo site
- [ ] Create / publish a production version of the docs site
- [x] Update demo site to allow for a different docs site using ENV var
