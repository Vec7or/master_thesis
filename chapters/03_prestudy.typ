#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl

= Overview
This prestudy is done in order to analyze the two lead questions defined in the task, which are:
1. What architectural principles enable the design of a secure update management system for embedded devices that can be flexibly expanded to accommodate new device types and communication technologies without compromising security or maintainability?
2. What has to be adapted in the current architecture to enable scalable software rollouts for several thousand embedded and industrial devices?

To answer those questions the previous work of the author regarding secure firmware updates for embedded devices @project-work-firmups is consulted. Since that project did not focus on scalability and extensibility, some additional analysis and research is done to better answer the questions posed. The results of the prestudy are then used to define the architecture of the #gls("poc", first: false) to be developed.

This prestudy is separated into two main chapters. One for each question posed in the task. The first chapter focuses on flexible expansion of the system to accommodate new device types and communication technologies. The second chapter focuses on the scalability of the system to support a large number of devices. Each chapter contains an analysis of the current state of the art regarding the topic, a discussion of the challenges and requirements, and a proposed design for the #gls("poc", first: false) to be developed in the main project.

= State of the art
== Post-quantum support in upstream MCUboot
The problem is recognised in the #gls("mcuboot", first: false) project but unresolved. A request for post-quantum support has been open since 2021 without a committed roadmap @mcuboot-pqc-discussion, and a single pull request adding #gls("lms", first: true) verification is open but has been inactive since June 2026, supports one parameter set, and explicitly provides simulator support only without any platform implementation @mcuboot-lms-pr. For #gls("ml-dsa", first: true) and #gls("slh-dsa", first: true) there is no upstream work at all. The crypto backend is equally incomplete: the PSA driver layer that #gls("mcuboot", first: false) builds against offers an experimental subset of #gls("ml-dsa", first: false) restricted to the ML-DSA-87 parameter set and not yet exposed to applications @tf-psa-crypto-mldsa.

== Vendor ports and competing bootloaders
Outside the upstream project, parts of the problem are solved in ways that do not transfer. The Renesas RA vendor port of #gls("mcuboot", first: false) documents verification with ML-DSA-44, ML-DSA-65 and ML-DSA-87, but is bound to one vendor's software package and crypto hardware @renesas-fsp-mcuboot. The competing bootloader wolfBoot supports #gls("ml-dsa", first: false), #gls("lms", first: false)/HSS and XMSS, as well as a hybrid mode in which a classical and a post-quantum signature are verified sequentially @wolfboot-pq-docs, with published verification figures for a Cortex-M7 class device @wolfboot-imx95. That hybrid mode is instructive, because it demonstrates the limitation this work targets: it fixes both algorithms at manufacturing time and therefore hardens a device against the arrival of quantum computers only if the correct pair was chosen before shipping. It does not allow the verification root of an already deployed device to be migrated.

== Published cost measurements
The cost of post-quantum signatures on constrained hardware is likewise partly known. Algorithm-level benchmarks for #gls("ml-dsa", first: false) exist for the Cortex-M0+ class @mldsa-cortexm0-bench, a short paper reports secure boot measurements showing that software-only ML-DSA-87 verification is an order of magnitude slower than hardware-accelerated ECDSA @ricardini-pq-secure-boot, and the effect of post-quantum signatures on #gls("suit", first: true) based updates for constrained devices was examined on a different operating system and update stack as early as 2021 @banegas-pq-suit.

== Resulting gap
What is missing is a measurement of these costs inside the #gls("mcuboot", first: false) boot path itself, where the immutable footprint of the verification code, the RAM high-water mark of the real image validation routine and the resulting update path are coupled, and an architecture that keeps the verification root migratable after deployment.

#text(fill: rgb("#cc0000"), size: 24pt)[ToDo!!]