#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl

= Overview

== About this chapter
The “Project Plan” chapter specifies the task, defines the schedule, and plans the project approach. It also specifies project processes as well as quality management. In summary, this chapter deals with the organizational aspects that must be defined before the technical part of the project can start. It also includes the project management methodology and tools used to manage the project.

== Task

=== Initial situation
The lifetime of deployed #gls("ot", first: true) devices is often in the order of 10 to 15 years and sometimes longer @nist-sp800-82r3[p.~30], and the lifespan of an #gls("ot", first: false) system as a whole can exceed 20 years @nist-sp800-82r3[p.~37]. The published migration timelines fall inside that window: the British #gls("ncsc", first: true) expects organisations to have completed a discovery exercise and an initial migration plan by 2028, and the migration to #gls("pqc", first: true) itself by 2035, with the highest-priority activities completed by 2031 @ncsc-pqc-migration-timelines. A device installed in 2026 is therefore commissioned before that deadline and will plausibly still be in operation in 2046, more than a decade after it. Hence the device must be able to migrate the cryptography it trusts while in operation.

For most of the software stack this is a manageable problem, because almost everything can be patched in the field. A secure boot chain, however, has to terminate in code that cannot be replaced. Architectures that make the bootloader upgradable only relocate that constraint into a small immutable first stage, whose verification root then stays fixed for the life of the device.

=== Objective
The goal of this project is to analyse crypto-agility and quantum readiness of the embedded secure boot and update mechanisms found in #gls("ot", first: false) as well as to develop and prototype an architecture that provides them.

=== Research questions
From this objective, the following three #glspl("rq", first: true) are derived:
1. Which properties must a firmware secure boot architecture provide to allow the verification root to be migrated after deployment on a long-lived constrained device?
2. How can the properties identified in question 1 be realised in a secure boot architecture, given the current state of the art?
3. What are the costs of post-quantum capable, crypto-agile secure boot for both the signature schemes and the agility mechanism itself?

=== Project scope
The project covers the verification side of secure boot and firmware update on one representative platform, and treats the signature schemes it migrates between as given.
- *Platform*: #gls("zephyr-rtos", first: false) together with #gls("mcuboot", first: true) serves as the reference implementation of secure boot on constrained industrial devices. The architectural results are formulated so that they carry over to comparable bootloaders. The measurements, however, are specific to this platform.
- *Signature verification*: this work focuses on signature verification in the boot chain and of the update image. Transport, manifest format and installation logic are taken as given.
- *Cryptography*: the standardised post-quantum signature schemes are used as published and their security is assumed, so that the analysis can concentrate on the migration mechanism rather than on the schemes themselves. Which schemes are examined is a result of the prestudy.
- *Cost model*: cost is expressed in flash, #gls("ram", first: true) and verification runtime, the metrics that can be measured reproducibly on the target hardware with the available toolchain.

=== Deliverables
The following artifacts are produced:
- List of properties needed for a crypto-agile boot architecture that supports migration of the verification root after deployment.
- #gls("poc", first: true) of an architecture fulfilling the properties identified during research for research question 1.
- A post-quantum signature integration for #gls("mcuboot", first: false) in upstreamable form, together with an extension of its `imgtool` signing tool.
- Comparison of flash and #gls("ram", first: false) consumption as well as signature verification time between the selected post-quantum schemes and the classical baseline on representative Cortex-M classes, with a reproducible measurement setup.

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

    taskgroup({
      task("1 Project plan", (1, 5), style: (stroke: 2pt + gray))
      task("2 Analysis", (5, 13), style: (stroke: 2pt + gray))
      task("3 Prototype", (13, 31), style: (stroke: 2pt + gray))
      task("4 Evaluation", (31, 37), style: (stroke: 2pt + gray))
      task("5 Report", (37, 41), style: (stroke: 2pt + gray))
    })

    milestone(
      at: 1,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Start of project\
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
      at: 13,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Properties fixed\
        13.12.2026
      ]),
    )

    milestone(
      at: 31,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Feature freeze\
        18.04.2027
      ]),
    )

    milestone(
      at: 37,
      style: (stroke: (dash: "dashed")),
      align(center, [
        Results complete\
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
The project runs in five phases. Of those only the prototype phase is iterative, because the research questions and the prototype have different completion criteria: #gls("rq", first: false) 1 and #gls("rq", first: false) 3 have to be answered conclusively, so the phases that answer them are time-boxed with a fixed scope. The prototype required by #gls("rq", first: false) 2 however may be handed over with a prioritised backlog.

=== Project plan
- Duration: 5 weeks
- Timeframe: 15.09.2026-18.10.2026
The task, the scope and the schedule are defined.\
*Done when*: this document is agreed upon with the advisor.

=== Analysis
- Duration: 8 weeks
- Timeframe: 18.10.2026-13.12.2026
The state of the art is analysed, the signature schemes to be examined are selected and the properties a crypto-agile root of trust has to provide are derived. Additionally the development environment, the target hardware and the measurement setup are established. A spike demonstrates that a post-quantum signature can be verified on the target hardware. Because the prototype is built against the list of properties, that list has to be complete before implementation starts.\
*Done when*: #gls("rq", first: false) 1 is answered. Should the spike show that the selected scheme cannot be verified on the target hardware, this counts as a result: the reasons are documented and the selection as well as the scope are adjusted with the advisor.

=== Prototype
- Duration: 18 weeks
- Timeframe: 13.12.2026-18.04.2027
The crypto-agile boot architecture and the post-quantum signature integration are implemented, together with the tests and most of the documentation. Work is planned in sprints of two weeks and reviewed at the end of each sprint, where unfinished items are re-prioritised or dropped. This is the only phase in which the scope may flex.\
*Done when*: migration of the verification root is demonstrable end to end and the code is under #gls("feature-freeze", first: false) so that every figure reported afterwards refers to the same state of it. A remaining backlog is acceptable here.

=== Evaluation
- Duration: 6 weeks
- Timeframe: 18.04.2027-30.05.2027
Flash, #gls("ram", first: false) and verification runtime are measured on the frozen prototype as well as for the classical baseline. The cost of the agility mechanism is separated from the cost of the schemes themselves. No feature work happens in this phase.\
*Done when*: #gls("rq", first: false) 3 is answered by a comparison over the selected schemes and the classical baseline, with a reproducible measurement setup.

=== Report
- Duration: 4 weeks
- Timeframe: 30.05.2027-25.06.2027
Final testing, bug fixing and finalisation of the report. It is also decided in this phase whether the integration is submitted upstream.\
*Done when*: the project work is submitted on 25.06.2027.

= Changelog of project plan
== Purpose
This changelog specifies all changes that were subsequently made to the project plan. All adjustments documented here have been discussed with the advisor and accepted by them.
