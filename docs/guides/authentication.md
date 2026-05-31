<!-- omit from toc -->
# Authentication & Error Handling


This guide covers adding user authentication and better error-handling tools to
a Rails application built in the LocoMotion style. It assumes you have already
followed the [Getting Started guide](getting-started.md) and have a running
Dockerized Rails app.

- [Authentication](#authentication)
- [Web Console](#web-console)
- [BetterErrors (Optional)](#bettererrors-optional)

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
> Although you can do this by using <kbd>Ctrl-C</kbd> and re-running `just
> app-fast`, a faster way to restart only the web server is to create a
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
Docker app container (`just app-shell`).

> [!TIP]
> You can also just kill (using <kbd>Ctrl-C</kbd>) and restart the container
> using `just app-fast` as this process attempts to install any gems for you.


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
