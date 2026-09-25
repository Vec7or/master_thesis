#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl

= Overview

== About this chapter
The “Project Plan” chapter specifies the task, defines the schedule, and plans the project approach. It also specifies project processes as well as quality management. In summary, this chapter deals with the organizational aspects that must be defined before the technical part of the project can start. It also includes the project management methodology and tools used to manage the project.

== Task

=== Initial situation
The lifetime of deployed #gls("ot", first: true) is often in the order of 10 to 15 years and sometimes longer @nist-sp800-82r3[p.~30], and the lifespan of an #gls("ot", first: false) system as a whole can exceed 20 years @nist-sp800-82r3[p.~37]. An industrial device that is installed in 2026 will therefore plausibly still be in operation in 2046, which is beyond currently published estimates for the arrival of a cryptographically relevant quantum computer. National migration timelines reflect this: the British #gls("ncsc", first: true) expects organisations to have completed a discovery exercise and an initial migration plan by 2028, and the migration itself by 2035 (2031 for the highest-priority activities) @ncsc-pqc-migration-timelines.

For most of the software stack this is a manageable problem, because almost everything can be patched in the field. A secure boot chain, however, has to terminate in code that cannot be replaced. Architectures that make the bootloader upgradable only relocate that constraint into a small immutable first stage, whose verification root then stays fixed for the life of the device.

=== Objective
The goal of this project is to analyse crypto-agility and quantum readiness of the embedded secure boot and update mechanisms found in #gls("ot", first: false) as well as to develop and prototype an architecture that provides them. MCUboot, the de facto secure bootloader of #gls("zephyr-rtos", first: true), serves as the platform for this work. It offers neither a post-quantum signature option nor a path for migrating its verification root. The detailed state of the art is analysed in #ref(<prestudy>).

=== Research questions
From this objective, the following three research questions are derived:
1. What does crypto-agility mean for the secure boot and firmware update path of a long-lived constrained device, and which properties must an architecture provide so that the verification root can still be migrated after deployment?
2. Which boot architecture provides these properties on MCUboot, and what does that agility cost in terms of the size of the architecture's own immutable boot stage and its attack surface?
3. What is the difference in flash and RAM consumption and in signature verification time between post-quantum and classical signature verification on representative Cortex-M classes?

=== Deliverables
The following artifacts are produced:
- A crypto-agility boot architecture that supports migration of the verification root after deployment, demonstrated by a working #gls("poc", first: true).
- A post-quantum signature integration for MCUboot in upstreamable form, together with an extension of its `imgtool` signing tool.
- Comparison of flash and RAM consumption as well as signature verification time between the selected post-quantum schemes and the classical baseline on representative Cortex-M classes, with a reproducible measurement setup.

== Assumptions and Limitations
=== Assumptions
- The security of the standardised post-quantum schemes is assumed. No cryptanalysis is performed.
- The migration deadlines published by national authorities are accepted as given and set the timeframe that the architecture is designed against.
- #gls("zephyr-rtos", first: false) together with MCUboot is taken as representative of secure boot on constrained industrial devices. Architectural findings are expected to transfer to comparable bootloaders, while absolute measurements are not.

=== Limitations
- True immutability is not reproduced on development hardware. Mask ROM or one-time-programmable storage is emulated by write-protected flash regions or lock bits, which approximates the constraint but does not reproduce it.
- The scope is the boot and firmware update trust chain. Transport security, provisioning and key management infrastructure as well as remote attestation and firmware image encryption are not covered. Only signature schemes are examined.
- No side-channel or fault-injection evaluation and no formal verification or security audit of the verification code are performed.
- Depending on backend availability, some schemes are integrated at prototype level rather than in production quality. Which ones is a result of the prestudy.
- The integration follows the contribution guidelines of the MCUboot project. Whether it is submitted is decided at the end of the project and acceptance is up to the upstream maintainers. Neither is a criterion for success.
- Neither fleet-scale rollout nor the 20-year service life can be tested within the project. Migration is demonstrated on a small number of devices and long-term behaviour is argued from the architecture.
- Measurements depend on toolchain, optimisation settings, board and clock configuration. They are comparable within this work rather than absolute.

#import "../dependencies/timeliney-0.4.0/timeliney.typ"
= Time Schedule
== Overview
#timeliney.timeline(
  milestone-layout: "aligned",
  show-grid: true,
  {
    import timeliney: *

    headerline(group(([*2026*], 17), ([*2027*], 25)))
    headerline(
      title: "Weeks",
      group(..range(42).map(n => if calc.rem(n, 2) == 0 { str(n) } else { "" })),
    )

    taskgroup(title: [*Phases*], {
      task("Inception", (0, 1), style: (stroke: 2pt + gray))
      task("Elaboration", (1, 11), style: (stroke: 2pt + gray))
      task("Construction", (11, 37), style: (stroke: 2pt + gray))
      task("Transition", (37, 41), style: (stroke: 2pt + gray))
    })

    milestone(
      at: 1,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Start of Project\
        15.09.2026
      ]),
    )

    milestone(
      at: 5,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Project plan\
        18.10.2026
      ]),
    )

    milestone(
      at: 11,
      style: (stroke: (dash: "dashed")),
      align(center, [
        End of Elaboration\
        29.11.2026
      ]),
    )

    milestone(
      at: 33,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Quality Measures\
        02.05.2027
      ]),
    )

    milestone(
      at: 37,
      style: (stroke: (dash: "dashed")),
      align(center, [
        End of Construction\
        30.05.2027
      ]),
    )

    milestone(
      at: 41,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Submission\
        25.06.2027
      ]),
    )
  },
)

== Phases
The phases are structured according to the #gls("scrum+", first: false) methodology. The project is divided into four phases: Inception, Elaboration, Construction, and Transition.

=== Inception
This phase would be intended for defining an idea for the project. Since the idea has already been defined beforehand, this phase is omitted. Effectively, there are therefore only three phases in the schedule. The inception phase is considered to be completed at the start of the project.

=== Elaboration
- Duration: 11 weeks
- Timeframe: 15.09.2026-29.11.2026
In this phase the state of the art is analysed, the signature schemes to be examined are selected, and the properties that a crypto-agile root of trust has to provide are derived. The development environment, the target hardware and the measurement setup are established, and a spike demonstrates that the selected post-quantum scheme can be verified on the target hardware. The scope of the #gls("poc", first: false) is also defined in this phase. The phase ends with the #gls("end-of-elaboration", first: false) milestone where it is decided whether the project can continue in this form or needs to be adjusted.

=== Construction
- Duration: 26 weeks
- Timeframe: 29.11.2026-30.05.2027
During this phase the heavy lifting is done: the crypto-agile boot architecture and the post-quantum signature integration are implemented in the #gls("poc", first: false), and the measurements are carried out. The phase ends with the "End of Construction" milestone where the implementation should be feature complete and ready for final testing and quality assurance. This is also the phase where tests and most of the documentation are written.

=== Transition
- Duration: 4 weeks
- Timeframe: 30.05.2027-25.06.2027
At the beginning of this phase the implementation should be feature complete and a #gls("feature-freeze", first: false) happens. The focus of this phase is final testing, quality assurance, bug fixing and finalizing the documentation. It is also decided in this phase whether the integration is submitted upstream. The phase ends with the submission of the project work.

== Iterations
The project is further divided into sprints of two weeks each. At the end of each sprint the current state of the project is reviewed and the plan for the next sprint is created. Should the need arise, adjustments to the overall project plan can be agreed upon with the advisor at this point.

== Milestones
Each milestone has work products. These work products are further divided into "Priority 1", which must be completed in this milestone, and "Priority 2", which can also be completed in the following milestone.

=== Project Plan
- *Goal*: Created and agreed upon a project plan
- *Date*: 18.10.2026
- *Work products*:
  - Priority 1:
    - Project plan document including time schedule, quality management plan, and project approach
- *Priorities and criteria for success*:
  - Project plan is complete and realistic
  - Project plan is agreed upon with the advisor

=== End of Elaboration
- *Goal*: The properties a crypto-agile root of trust has to provide are derived, the signature schemes to be examined are selected, and it is demonstrated on the target hardware that a post-quantum signature can be verified in the bootloader (technical breakthrough). A draft of the architecture and the threat model are defined.
- *Date*: 29.11.2026
- *Work products*:
  - Priority 1:
    - #gls("end-of-elaboration-checklist", first: false) checked off
    - Prestudy with the analysis of the state of the art and the selection of the signature schemes to be examined
    - Architectural draft of the crypto-agile boot architecture and the threat model
    - Source code of the spike
    - Measurement setup for flash, #gls("ram", first: true) and verification time
  - Priority 2:
    - Updated documentation
- *Priorities and criteria for success*:
  - For this milestone the technical breakthrough is the most important part. The development environment, the target hardware and the toolchain need to be set up and understood. The architecture needs to be defined at a high level, but does not need to be fully fleshed out yet.
  - Should the spike show that the selected scheme cannot be verified on the target hardware, this counts as a result. The reasons are documented and the selection as well as the scope are adjusted in agreement with the advisor.

=== Quality Measures
- *Goal*: The architecture is implemented in its biggest parts. A post-quantum signature can be verified in the bootloader on the target hardware and the verification root can be migrated. The most important functionality is implemented and tested.
- *Date*: 02.05.2027
- *Work products*:
  - Priority 1:
    - Source code of the implementation
    - First measurement results for the classical baseline and at least one post-quantum scheme
  - Priority 2:
    - Test code and documentation
- *Priorities and criteria for success*:
  - The code should be implemented in its biggest parts. Migration of the verification root should be demonstrable end to end, even if not yet for every selected scheme.

=== End of Construction
- *Goal*: Implementation is feature complete. Prioritization of backlog and #gls("feature-freeze", first: false)
- *Date*: 30.05.2027
- *Work products*:
  - Priority 1:
    - Source code of the implementation
    - Complete comparison of flash and #gls("ram", first: false) consumption and verification time
  - Priority 2:
    - Test code and documentation updated to the final state of the implementation
- *Priorities and criteria for success*:
  - The #gls("poc", first: false) implementation should fulfill the requirements set in the task and all research questions should be answerable from the results available at this point.

=== Submission
- *Goal*: Submit the project work
- *Date*: 25.06.2027
- *Work products*:
  - Priority 1:
    - Final project report
    - Source code of the implementation
  - Priority 2:
    - Contribution prepared for upstream submission
- *Priorities and criteria for success*:
  - The priority for this milestone is the final project report since it has a bigger weight than the implementation. The implementation should be in a state that it can be used and further developed after the project.

= Organization
== Meetings
Meetings with the advisor will be held every two weeks at the end of each sprint. If needed additional meetings can be scheduled. The meetings will be used to discuss the current state of the project, any issues that have arisen, and the plan for the next sprint.

== Project methodology
The project is being managed using the #gls("scrum+", first: false) methodology. This method was also used in previous projects by the author and worked well. The #gls("scrum+", first: false) methodology allows for flexibility and adaptability in the project plan, which is necessary when the scope might change during the project.

= Quality Measures
== Project Management
The basis for the project management is a project board located on #gls("github", first: false). The project board is used to track the progress of the project and to manage the backlog of tasks. The project board is divided into three columns: "To Do", "In Progress", and "Done". Tasks are moved from one column to the next as they are worked on and completed. The tasks are assigned to their respective milestones to keep track of the progress towards each milestone. Time tracking will be done separately using #gls("clockify", first: false) as the time-tracking tool.

== Documentation
The documentation is located in a separate repository on #gls("github", first: false).

== Development
The source code is versioned using Git and is located in separate repositories depending on the component, but all components are in the same organisation on #gls("github", first: false).

= Project processes
== Tools
For project management the following tools are used:
- #gls("github", first: false)
  - Project board for task management
  - Repositories for source code and documentation
  - #gls("github-actions", first: false) for CI/CD
- #gls("typst", first: false)
  - Documentation
- #gls("clockify", first: false)
  - Time tracking
- #gls("claude", first: false)
  - Assistance with documentation:
    - Rewriting of passages
    - Grammar and spell checking
  - Assistance with code:
    - Code snippets like switch cases
    - Auto completion
    - Secondary code like UI but not core architecture or concepts

== Process
=== Sprint-Review and Planning
During the project there is one main process that is followed:
1. At the start of each sprint the tasks for the sprint are planned and added to the project board.
2. During the sprint the tasks are worked on and moved through the columns on the project board.
3. At the end of the sprint the current state of the project is reviewed and the plan for the next sprint is created.
  - Should not all tasks be completed, they are re-evaluated and either moved to the next sprint or removed from the backlog.
4. If needed, adjustments to the overall project plan are made.

=== Development process
The development process follows the Git workflow used by many open-source projects and is based on an adjusted #gls("tbd-workflow", first: true). The main points of the workflow are:
- There is a branch called "main" which contains the stable version of the code/documentation.
- For each feature or task a separate branch is created from the main (trunk) branch.
  - The feature branch is based on a task.
  - The feature branch is merged back into the main branch when the feature is complete.
    - Must pass build and tests before it can be merged.
- Each release is tagged with a version number and a changelog is created for each release.
  - (not #gls("tbd-workflow", first: false)) Also a release branch is created for each release which is used for bug-fix and hotfix backporting.
For tasks, the following additional rules apply:
- Each task is represented by an issue on #gls("github", first: false).
- Each task is assigned to a milestone.
- Time tracking is done for each task using #gls("clockify", first: false).


= Changelog of project plan
== Purpose
This changelog specifies all changes that were subsequently made to the project plan. All adjustments documented here have been discussed with the advisor and accepted by them.
