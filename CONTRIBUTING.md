<!-- omit from toc -->
# Contributing

loco_motion is excited to be an Open Source project where anyone can contribute
to make it even better. We would love for you to join in the fun and help us
build something that brings **real** value to thousands of developers!

Below are our guides for contributing to this project.

- [Setup](#setup)
- [Project Layout](#project-layout)
- [Getting Started](#getting-started)
  - [Creating Components](#creating-components)
- [TODO](#todo)

## Setup

The first thing you'll need to do is get the project up-and-running on your
machine. Since we eat our own dogfood, much of the README will be relevant here.

In particular, we utilize Docker to build and run our application and all of its
dependencies.

Once you've downloaded and setup Docker, all you should have to do is open a
terminal in the project directory and type `make all`. This should build all of
the Docker containers, install all relevant dependencies, install Rails and all
of the necessary gems, and start all of the different services.

If everything is successfull, you should see some output from each of the
running containers with information on how to connect.

You can view the YARD Docs at http://localhost:8808 and the demo app should be
running at http://localhost:3000.

You should also see some info from the JS / CSS watchers that they are running
and waiting for file changes to rebuild the app. Because we utilize TailwindCSS,
we need to compile new CSS after every change and make sure our built CSS has
all of the used Tailwind classes and any custom code that we've built.

## Project Layout

loco_motion is split into three main directories:

 - `lib` - This holds all of the gem-specific code such as base classes and
   helpers.
 - `app/components` - All of the components for the various frameworks we
   support (currently only the DaisyUI framework).
 - `docs/demo` - This directory is the demo application that utilizes the
   loco_motion Gem and shows all of the different ways we can use it.

The `examples` directory gives developers a starting point for building their
own applications, and is not used directly by loco_motion.

## Getting Started

The best way to contribute is to create a new Pull Request on our GitHub
repository. You can fork the repository and create PRs from your fork, or you
can reach out to topher@profoundry.us if you are interested in becoming a core
contributor and having direct access to the repo.

At the moment, we need to be building out new components. Our current goal is to
build all of the components available at https://daisyui.com/components/. In the
future, we may look at providing components for other libraries, or even custom
components only available through loco_motion.

### Creating Components

In order to create a new component, you'll need to create the appropriate
`*_component.rb` file in the relevant directory inside of the
`app/components/daisy` folder. You'll also need to create a new `*_component`
sidecar directory to store the relevant HAML, JS, and CSS files.

For example, if you wanted to add the Alert component
(https://daisyui.com/components/alert/), you would need to

1. Create a new directory called `feedback` inside of `app/components/daisy` (
   because we don't currently have that section).
2. Create a new file called `alert_component.rb` inside the
   `app/components/daisy/feedback` folder.
3. Create a new folder called `alert_component` inside the
   `app/components/daisy/feedback` folder.

You can look at any of the other components to help you get started. One of the
main things to remember is that all setup needs to happen in the `before_render`
method rather than the `initializer` method as some of the typical component
setup will require the component to be initialized before you can call those
methods.

The `ButtonComponent` is a very simple component you an use for reference, and
the `ModalComponent` is one of the more complex ones which shows a lot of the
features of loco_motion.

## TODO

There are a lot of tasks left to be done.

 - [ ] Add a Stimulus controller to the modal component
 - [ ] Auto-load all Stimululs controllers when including (or using?) a
       component
 - [ ] Build out all of the component
 - [ ] Create a logo and use it in the layout
 - [ ] Extract the navigation into a partial or custom component (would be a
       good use-case for custom components)
 - [ ] Consider using FontAwesome icons instead of Heroicons /
       https://simpleicons.org/ since there are far more available
       (particularly social icons)
 - [ ] Much much more :D
