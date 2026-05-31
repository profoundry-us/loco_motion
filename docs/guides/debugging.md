<!-- omit from toc -->
# Debugging & Testing


This guide covers the debugging and testing tools we recommend when building a
Rails application in the LocoMotion style. It assumes you have already followed
the [Getting Started guide](getting-started.md) and have a running Dockerized
Rails app.

- [Debugging](#debugging)
- [Testing](#testing)
- [Services / Service Objects](#services--service-objects)

## Debugging

The latest version of Rails makes it much easier to debug within a Docker
container as it automatically starts a remote debugger for you.

Add the word `debugger` anywhere in your code (perhaps the `test` method of your
`ApplicationController`), reload the page (it will look like it's hanging), and
then run `just app-debug` in a separate terminal.

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
recommend Rspec with [factory_bot](https://github.com/thoughtbot/factory_bot)
and [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers).

Finally, although both libraries offer some functionality for testing your user
interface, we recommend utilizing [Playwright](https://playwright.dev/) instead
as it more closely mimics the real user experience in a browser and it allows
you to see in real-time what is happening, including in-browser debugging!

Although the common setup is to write your specs in JavaScript or TypeScript,
you can actually write your End to End tests in Ruby / Rspec by utilizing the
[playwright-ruby-client](https://playwright-ruby-client.vercel.app/)!

We'll have some guides and examples for this coming soon!

> [!NOTE]
> We used to recommend [Cypress](https://www.cypress.io) for End-to-End tests,
> but it's reliance on JavaScript and sometimes flakey tests caused us to search
> out a new solution / recommendation.
>
> We plan to have a writeup soon (an ADR specifically) on exactly why we made
> the switch.

## Services / Service Objects

It is best practice to separate your logic into Service Objects rather than
shoving all of it into your Controllers and Models.

One solution we really like is
[ActiveInteraction](https://github.com/AaronLasseigne/active_interaction).

It is very stable, has wonderful documentation, and gives you a clean way to
build your service objects with support for things like composed interactions
and even ActiveModel validations.

Add `gem 'active_interaction', '~> 5.3'` to your `Gemfile` and create a new
class called `ApplicationInteraction` if you want to give it a try!

```
# app/interactions/application_interaction.rb
class ApplicationInteraction < ActiveInteraction::Base
  # Your interactions will inherit from this class!
end
```
