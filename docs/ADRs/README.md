<!-- omit from toc -->
# Architectural Decision Records

What are ADRs and why should we use them?

<!-- toc -->
- [Purpose](#purpose)
- [Format](#format)
- [Types](#types)
  - [Foundational](#foundational)
  - [Lightweight](#lightweight)
- [Naming Conventions](#naming-conventions)
- [Additional Resources](#additional-resources)
- [TODO](#todo)
  - [Potential ADRs](#potential-adrs)
<!-- tocstop -->

## Purpose

ADRs, or Architectural Decision Records (also sometimes called Architectural
Design Records), are documents that describe decisions that need to be made
during the course of developing software applications or other complex systems.

When trying to understand a large and complex system, it is often helpful to
review the reasoning that went into much of it's design. ADRs give us a way to

  1. Organize that reasoning, which ensures that all parties involved in the
     decision-making process are aligned on the constraints and requirements;
  2. Come to a consensus on the proposed solution; and
  3. Document the solution, and the decision process, for later review.

This can be extremely beneficial for new developers coming into your codebase,
so they can get up to speed more quickly on how your system operates. But it can
also be very useful for downstream developers if you're building a reusable
piece of code.

LocoMotion has chosen to utilize ADRs for the following reasons.

  1. As a sole developer starting the project, I want a way to better organize
     my thoughts and document the pros & cons of particular solutions.
  2. If and when other developers begin contributing to the project, I want them
     to have a wealth of documentation to review so they can get up to speed
     very quickly and efficiently.
  3. When others begin to contriubte, I want a well-defined process for making
     decisions as a group / community.
  4. And finally, since the goal of LocoMotion is to provide the fastest and
     most efficient way for web developers to build Ruby on Rails applications,
     I want those downstream developers to better understand why the library
     works the way it does so that they can make better decisions about how they
     write their own custom components and code.

## Format

ADRs typically follow a particular format chosen by the project or group. For
general projects, this usually includes things like

  * The current status of the ADR (proposed, in-review, accepted)
  * The parties involved in the decision process
  * Any context, constraints, and resources related to the decision
  * The proposed solution (with sub-sections going in-depth into various aspects
    of the proposed solution)
  * Any alternative solutions that were considered
  * The pros & cons of the potential solutions
  * And any consequences of choosing the proposed solution

For software projects specifically (and perhaps others), ADRs might also include
things like

  * Considerations around scaling and security
  * Any database / code changes that need to be made
  * How the solution will be rolled out (feature flags / releases / etc)
  * Estimated milestones and order / priority of work

Finally, I personally find it useful to have sections in the ADR to help track
the tasks related to creating the ADR / solution, open questions that need to be
answered before making the decision, and a place to track unorganized ideas such
as a brainstorming section.

Typically, items / ideas in the brainstorming section will be moved (or perhaps
duplicated / refined) into the appropriate solution sub-sections within the ADR.

## Types

There are many types of ADRs, but we primarily use the following two for our
needs.

  * **Foundational -** Major architectural decisions about the system(s) as a
    whole.
  * **Lightweight -** Smaller, more specific ADRs about particular pieces of the
    system.

Each of these has a `TEMPLATE.md` file that can be used as a starting point for
building your ADRs.

### Foundational

Foundational ADRs are the primary form of ADRs that you will use for making
decisions about how to build your application.

Typically, this includes things such as

  * What libraries or frameworks you will be using
  * Any overarching design patterns used throughout the system
  * How core models relate to one another
  * New features that are large and complex
  * Major refactorings that affect big chunks of the application
  * Anything else that has large-reaching effects

By reading through all of the Foundational ADRs, a new developer should have a
pretty good idea of not only of how the system works, but also why it works that
particular way. ADRs are documentation that enable people to see the _reasoning_
behind the decisions that were made. As such, it can be a very valuable resource
for onboarding new hires.

### Lightweight

Lightweight ADRs are typically slimmed down versions of a foundation ADR that
are built to document decisions about a particular piece of the system.

These are great for when you need to

  * Decide relationships between a small sub-set of models
  * Refactor a class or two
  * Add a smaller feature with less impact
  * Brainstorm a solution to a particularly nasty bug
  * Or any other smaller decisions that require discussion and consesus

It's not anticipated that developers read every lightweight ADR, but rather use
them as a resource when new problems arise. Ideally, these are searchable and
developers will learn to poke around a bit before coming up with new solutions,
but they can also be valuable as a method of knowledge transfer when
conversations are in progress and more experienced developers can recall an
existing ARD and pass it on to the appropriate parties.

## Naming Conventions

It is nice to have a slight bit of organization to the ADRs files that you
create. That said, there is also a lot of value in being able to see the order
in which decisions about the system were made.

Therefore, we try to keep folder organization to a minimum and make sure to
start our files names with the year and month in which they began their life.

Additionally, you should choose a descriptive name for the decision you need to
make, rather than the choice that was made (or you expect to make).

For example, if you're building an ADR about which testing framework to use, you
might name your file `202403_testing_framework.md` and put it in the
`foundational` folder.

> [!NOTE]
> We recommend using lower-case for consistency, but this is purely preference.

On the other hand, if you are building an ADR about the relationships between a
few models, you might name your file
`202405_author_post_comment_relationships.md` and put it in the `lightweight`
directory.

## Additional Resources

There are a lot of resources available if you just search Google for
`architecture decision record`, but here are a few that we can whole heartedly
recommend.

  * https://adr.github.io/

  * https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html

## TODO

- [x] Talk about the templates
- [x] Build the arch template
- [x] Build the lightweight template
- [x] Discuss naming conventions
  * Include year / month at start?
  * Use dashes or underscores
  * Capitalization
- [ ] Mention general guidelines regarding how long it should take to draft,
      review, and approve ADRs
- [x] Create first ADR regarding sizes / variants
- [x] Discuss the difference between large ADRs and lightweight ADRs
  * Maybe separate / organize them in your docs
- [x] Talk more about the lightweight ADRs and their purpose
- [ ] Discuss best way to get started with LocoMotion's ADRs specifically
- [x] Add resources to other ADR knowledge
- [x] Rename to `Architectural Decision Records` but mention how some people use
      the design moniker

### Potential ADRs

- [ ] Rename LocoMotion `variants` to avoid conflicts with ViewComponent
  * VC already has a concept of variants which is different than LM
  * Use a meaningful name that doesn't conflict (`styles`?)
  * Refactor to allow multiple variants at once (`primary` & `outline`)
