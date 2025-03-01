<!-- omit from toc -->
# Contributing to LocoMotion

Thank you for your interest in contributing to LocoMotion! This document
provides guidelines and instructions for contributing to this project.

LocoMotion is excited to be an Open Source project where anyone can contribute
to make it even better. We would love for you to join in the fun and help us
build something that brings **real** value to thousands of developers!

- [Code of Conduct](#code-of-conduct)
- [Setup](#setup)
- [Project Layout](#project-layout)
- [Getting Started](#getting-started)
  - [Creating Components](#creating-components)
- [Making Changes](#making-changes)
- [Documentation](#documentation)
- [Testing](#testing)
- [Pull Requests](#pull-requests)
- [Release Process](#release-process)
- [TODO](#todo)

## Code of Conduct

We expect all contributors to follow professional and respectful behavior when
interacting with the community.

## Setup

The first thing you'll need to do is get the project up-and-running on your
machine. Since we eat our own dogfood, much of the README will be relevant here.

In particular, we utilize Docker to build and run our application and all of
its dependencies.

Once you've downloaded and setup Docker, all you should have to do is open a
terminal in the project directory and type `make all`. This should build all of
the Docker containers, install all relevant dependencies, install Rails and all
of the necessary gems, and start all of the different services.

> [!NOTE]
> For normal day-to-day development after the initial setup, you can use
> `make all-quick` instead of `make all`. This will skip rebuilding the Docker
> containers and is much faster for routine development work.

If everything is successful, you should see some output from each of the running
containers with information on how to connect.

You can view the YARD Docs at http://localhost:8808 and the demo app should be
running at http://localhost:3000.

> [!TIP]
> The YARD documentation and demo app examples are a valuable resource for understanding the codebase.
> It provides detailed information about classes, methods, and components.
> Always check the documentation first when you have questions about how a
> component works or how to use it.

You should also see some info from the JS / CSS watchers that they are running
and waiting for file changes to rebuild the app. Because we utilize TailwindCSS,
we need to compile new CSS after every change and make sure our built CSS has
all of the used Tailwind classes and any custom code that we've built.

## Project Layout

LocoMotion is split into three main directories:

- `lib` - This holds all of the gem-specific code such as base classes and
  helpers.
- `app/components` - All of the components for the various frameworks we
  support (currently only the DaisyUI framework).
- `docs/demo` - This directory is the demo application that utilizes the
  LocoMotion Gem and shows all of the different ways we can use it.

The `examples` directory gives developers a starting point for building their
own applications, and is not used directly by LocoMotion.

## Getting Started

The best way to contribute is to create a new Pull Request on our GitHub
repository. You can fork the repository and create PRs from your fork, or you
can reach out to topher@profoundry.us if you are interested in becoming a core
contributor and having direct access to the repo.

At the moment, we need to be building out new components. Our current goal is to
build all of the components available at https://daisyui.com/components/. In
the future, we may look at providing components for other libraries, or even
custom components only available through LocoMotion.

### Creating Components

In order to create a new component, you'll need to create the appropriate
`*_component.rb` file in the relevant directory inside of the
`app/components/daisy` folder. You'll also need to create a new
`*_component.html.haml` file and potentially a `*_controller.js` file if the
component requires Javascript.

For example, if you wanted to add the Timeline component
(https://daisyui.com/components/timeline/), you would need to:

1. Create a new directory called `data_display` inside of `app/components/daisy`
   (if it doesn't already exist).
2. Create a new file called `timeline_component.rb` inside the
   `app/components/daisy/data_display` folder.
3. Create a new file called `timeline_component.html.haml` inside the
   `app/components/daisy/data_display` folder.

You can look at any of the other components to help you get started. One of the
main things to remember is that all setup needs to happen in the `before_render`
method rather than the `initialize` method as some of the typical component
setup will require the component to be initialized before you can call those
methods.

The `ButtonComponent` is a very simple component you an use for reference, and
the `ModalComponent` is one of the more complex ones which shows a lot of the
features of LocoMotion.

## Making Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feat/your-feature-name
   # OR
   git checkout -b fix/some-broken-thing
   ```

2. Make your changes following our coding conventions:
   - Follow the principles of KISS (Keep It Stupid Simple)
   - Follow the principles of DRY (Don't Repeat Yourself)
   - Follow existing code patterns and styles

3. Ensure all tests pass:
   ```bash
   make loco-test
   ```

## Documentation

All new features should include appropriate documentation:

- Use YARD for code documentation
- Follow our documentation conventions:
  - Use the `@part` macro for components that use `define_part` or `define_parts`
  - Use the `@slot` macro for components that use `renders_one` or `renders_many`
  - Use `@loco_example` for examples
  - Document parameters with `@param` and `@option`
  - All documentation should have proper punctuation
  - Follow the order outlined below:
    1. Description
    2. Notes (Optional)
    3. Parts
    4. Slots
    5. Examples

## Testing

All new code should include tests:

1. Write tests for your changes following the patterns in existing test files
2. Ensure all tests pass before submitting a pull request
3. Run tests using `make loco-test`

## Pull Requests

1. Ensure your code passes all tests
2. Submit a pull request with a clear description of the changes
3. Reference any related issues in your pull request
4. Follow the PR template provided in the repository

> [!NOTE]
> We will update the CHANGELOG.md with your changes when we merge your PR.

> [!IMPORTANT]
> Always run `make loco-test` before submitting a pull request to ensure all
> tests are passing. This helps maintain the quality and stability of the
> codebase. Also make sure to update the CHANGELOG.md with your changes.

## Release Process

For information about the release process, please refer to
[RELEASING.md](RELEASING.md).

> [!WARNING]
> Only core team members should perform releases. If you believe a release is
> needed, please contact a core team member instead of attempting to release
> yourself. Improper releases can cause problems for users of the gem.

## TODO

There are a lot of tasks left to be done. Please see the TODO section at the
bottom of the README for more information.
