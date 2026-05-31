<!-- omit from toc -->
# loco_motion

Crazy fast Rails development with modern tools and components leveraging
ViewComponent, TailwindCSS, DaisyUI and more!

<img src="//loco-motion-docs.profoundry.us/images/loco-chats.png" width="500px" style="border: 1px solid #bbb; padding: 2px; border-radius: 10px;">

<!-- omit from toc -->
## Contents

- [About](#about)
- [Current Status](#current-status)
- [Installation](#installation)
- [Using Components](#using-components)
- [Guides](#guides)
- [Documentation & Demo](#documentation--demo)
- [Developing](#developing)
  - [Contributing](#contributing)
  - [Releasing](#releasing)
  - [Tooling](#tooling)
- [Getting Help](#getting-help)
- [TODO / Next Steps](#todo--next-steps)


## About

loco_motion is both a set of philosophies and paradigms for developing robust
web applications in Ruby on Rails, as well as a set of gems and tools to help
you execute on your vision quickly and reliably.

At its core, LocoMotion is a Rails ViewComponent library that wraps
[DaisyUI](https://daisyui.com/) components with a clean, Ruby-first API. It
generates semantic, accessible UI elements using Tailwind CSS classes.

It also includes standards and recommendations for your

 * Development Environment
 * Testing / Debugging
 * CSS / Page Markup
 * Components / Libraries
 * Releasing / Hosting
 * and much more!

You can use as much or as little of the frameworks and philosophies provided,
and you can customize it all to your heart's content. If you just want the
components, jump straight to [Installation](#installation). If you want the full
opinionated project setup, start with the [Guides](#guides).

## Current Status

This project is in active development and many changes occur with every release!

As of **v0.5.x**, LocoMotion ships with **Tailwind 4** and **DaisyUI 5**. The
install approach has changed from previous versions, so please follow the
updated instructions below.

> [!CAUTION]
> LocoMotion is in active development. Components are functional but APIs may
> change between minor releases. Pin to a specific version in production.

Many of the DataInput elements (file input, text input, select dropdown, etc)
were built as a base version to start from. DaisyUI 5 redesigned these
components significantly, so they are being incrementally improved as we use
them in real projects.

## Installation

Add the following to your `Gemfile` and re-run `bundle`:

```ruby
# Gemfile

gem "loco_motion-rails", "~> 0.5.2", require: "loco_motion"
```

Next, create or update your `tailwind.config.js` to tell Tailwind where to
scan for component class names. In Tailwind 4, this file handles **only**
content paths — plugins belong in your CSS file (see the
[Getting Started guide](https://loco-motion.profoundry.us/guides/04_getting_started)).

```js
const { execSync } = require('child_process');
let locoBundlePath =
  execSync('bundle show loco_motion-rails').toString().trim();

module.exports = {
  content: [
    `${locoBundlePath}/app/components/**/*.{rb,js,html,haml}`,
    'app/components/**/*.{rb,js,html,haml}',
    'app/views/**/*.{rb,js,html,haml}',
  ]
}
```

> [!WARNING]
> Note that `bundle show loco_motion-rails` will output nothing if the gem
> is not installed or the name is wrong, causing Tailwind to skip all
> component classes. Make sure the gem name matches exactly.

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

import {
  CountdownController,
  ThemeController,
  AlertController,
  CallyInputController
} from "@profoundry-us/loco_motion"

const application = Application.start()

// Register each controller under its `loco-*` Stimulus identifier. These
// names are required: the components render `data-controller="loco-..."`, so
// registering under any other name means the controller never connects.
application.register("loco-countdown", CountdownController)
application.register("loco-theme", ThemeController)
application.register("loco-alert", AlertController)
application.register("loco-cally-input", CallyInputController)

export { application }
```

## Using Components

Components are rendered like any other Rails ViewComponent, but LocoMotion also
provides ergonomic `daisy_*` helper methods.

```haml
%div
  = render(Daisy::Actions::ButtonComponent.new(title: "Click Me"))

%div
  = daisy_button(css: "btn-primary") do
    Click Me Too
```

DaisyUI variants are applied by passing DaisyUI classes directly via the `css:`
option — there are no `color:` or `size:` parameters:

```haml
= daisy_button(css: "btn-primary btn-lg")
```

For the full set of available components, parts, slots, and live examples, see
the [demo site](https://loco-motion.profoundry.us/) and the
[API documentation](#documentation--demo).

## Guides

These optional guides cover the broader LocoMotion philosophies and a
recommended, opinionated setup for a brand-new Rails project. You do **not**
need them to use the gem — they are published on the
[demo site](https://loco-motion.profoundry.us/guides/04_getting_started):

- [Getting Started](https://loco-motion.profoundry.us/guides/04_getting_started) —
  Stand up a new Dockerized Rails app with HAML, TailwindCSS, and DaisyUI.
- [Docker](https://loco-motion.profoundry.us/guides/01_docker) — A consistent,
  reliable development environment for any OS.
- [HAML](https://loco-motion.profoundry.us/guides/02_haml) — Cleaner,
  indentation-based templates for a better developer experience.
- [Debugging & Testing](https://loco-motion.profoundry.us/guides/03_debugging) —
  Set up RSpec, Playwright, and the remote debugger.
- [Service Objects](https://loco-motion.profoundry.us/guides/05_services) —
  Structure your business logic with ActiveInteraction.
- [Authentication](https://loco-motion.profoundry.us/guides/06_authentication) —
  Wire up OmniAuth, the Web Console, and BetterErrors.

## Documentation & Demo

We expect to settle on and purchase a real domain name in the near future, but
for the time being, the latest documentation is available at the links below.

 - [Latest Release][1]
 - [Main / Staging][3]

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

You should then be able to run `just rebuild` in the project directory and then
`just all-quick` to start the services.

> [!NOTE]
>
> We use `yarn link` in the `docs/demo/bin/setup` script to enable quick editing
> of the Javascript files so you don't have to publish new packages during
> testing.
>
> For the Ruby gem, we point directly to it via the `:path` option in the
> `Gemfile`. This means that we have a custom Heroku buildpack when we publish
> the demo site to move the files into the appropriate places.
>
> See https://github.com/profoundry-us/loco_motion-buildpack for more info.

From here, you can access the demo site at http://localhost:3000 and the YARD
docs at http://localhost:8808/docs/yard

You can type `just demo-shell` to open a shell inside the demo Docker container,
or `just loco-shell` to get a shell inside the gem's Docker container.

See the `justfile` for all available commands.

> [!WARNING]
>
> Right now, Rails doesn't auto-reload the LocoMotion library files when they
> change, so you might have to restart your server to get it to pickup the
> changes.
>
> ```sh
> just demo-restart
> ```

### Contributing

If you're interested in contributing to LocoMotion, please check out our
[CONTRIBUTING guide](docs/dev_guides/CONTRIBUTING.md) which provides detailed
information about the contribution process, code standards, documentation
requirements, and testing procedures.

### Releasing

For core team members who need to release new versions of LocoMotion, please
refer to our [RELEASING guide](docs/dev_guides/RELEASING.md) for step-by-step
instructions on version updates, building, testing, and publishing both the Ruby
gem and NPM package.

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

## Getting Help

Please reach out by opening an
[Issue](https://github.com/profoundry-us/loco_motion/issues) if you've found a
bug or starting a
[Discussion](https://github.com/profoundry-us/loco_motion/discussions) if you
have a question!

Please open a Discussion / Issue **before** starting a Pull Request to make sure
we aren't already working on the suggested feature / bug, and to ensure that
your solution is aligned with our goals.

## TODO / Next Steps

There is a LOT left to be done. We're not currently seeking assistance, but if
you feel very strongly that you'd like to contribute, please reach out through
the GitHub Discussions feature and let us know!

- [ ] Choose, recommend, and document a pagination gem
- [ ] Discuss caching techniques / setup
- [ ] Build some docs / guides / examples for using playwright-ruby-client
- [ ] See if we can update the Join component to auto-add the `join-item` CSS
      under certain conditions
- [ ] Add title and description content_for blocks to all examples for SEO
      purposes
- [ ] Rename the `Dockerfile` to `Dockerfile.loco` to be more concise
- [ ] Make the tooltips documentation button a component and use it for the
      Labelable concern docs too

[1]: https://loco-motion.profoundry.us/
[2]: https://loco-motion-demo-staging.profoundry.us/
[3]: https://loco-motion-demo-staging.profoundry.us/api-docs
