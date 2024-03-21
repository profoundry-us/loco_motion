# Architecture Design Records

What are ADRs and why should we use them?

## Purpose

ADRs, or Architecture Design Records, are documents that describe decisions that
need to be made during the course of developing software applications or other
complex systems.

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

# TODO

  * Talk about the template
  * Build the template
  * Discuss naming conventions
    * Include year / month at start?
    * Use dashes or underscores
    * Capitalization
  * Mention general guidelines regarding how long it should take to draft,
    review, and approve ADRs
  * Create first ADR regarding sizes / variants
  * Discuss the difference between large ADRs and lightweight ADRs
    * Maybe separate / organize them in your docs
  * Discuss best way to get started with LocoMotion's ADRs specifically
  * Add resources to other ADR knowledge
    * https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html
    * https://adr.github.io/
