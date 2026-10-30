#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl

= Overview
This prestudy answers #gls("rq", first: false) 1 of the task, which asks which properties a firmware secure boot architecture must provide to allow the verification root to be migrated after deployment on a long-lived constrained device. In doing so it also prepares the two remaining #glspl("rq", first: false): it establishes against which state of the art the architecture of #gls("rq", first: false) 2 has to be built, and it selects the post-quantum signature schemes whose cost is measured in #gls("rq", first: false) 3.

The chapter is structured in three steps:
- The first part reviews the state of the art. From this the gap this work addresses is stated.
- The second part selects the signature schemes to be examined.
- The third part derives the list of properties a crypto-agile boot architecture has to provide, which serves as the specification against which the #gls("poc", first: false) is designed in #ref(<architecture>) and verified later.

= State of the art


== Post-quantum support in upstream MCUboot
Upstream #gls("mcuboot", first: false) acknowledges the problem but has not resolved it. A discussion thread on post-quantum support has been open since 2021 and still sees activity, yet no maintainer has committed to a roadmap @mcuboot-pqc-discussion. The only concrete contribution is a single pull request adding #gls("lms", first: true) verification, which has been open since June 2026 @mcuboot-lms-pr.

The narrow scope of that pull request reflects the crypto backend beneath it. The PSA driver layer MCUboot builds against exposes only a limited subset of #gls("ml-dsa", first: true): experimental, restricted to ML-DSA-87 and not yet reachable from applications. #gls("lms", first: false) is likewise available in a single parameter set, and it is that parameter set the pull request adopts @tf-psa-crypto.

== Vendor ports and competing bootloaders
Outside the upstream project, parts of the problem are solved in ways that do not transfer. The Renesas RA vendor port of #gls("mcuboot", first: false) documents verification with ML-DSA-44, ML-DSA-65 and ML-DSA-87 over Mbed TLS @renesas-fsp-mcuboot. The parameter coverage therefore exceeds what the upstream backend offers, which places the support in a vendor-maintained #gls("sdk", first: true) rather than upstream. The competing bootloader wolfBoot supports #gls("ml-dsa", first: false), #gls("lms", first: false)/#gls("hss", first: true) and #gls("xmss", first: true), as well as a hybrid mode in which a classical and a post-quantum signature are verified sequentially @wolfboot-pq-docs, with published verification figures for a Cortex-M7 class device @wolfboot-imx95. That hybrid mode is instructive, because it demonstrates the limitation this work targets: it fixes both algorithms at manufacturing time and therefore hardens a device against the arrival of quantum computers only if the correct pair was chosen before shipping. It does not allow the verification root of an already deployed device to be migrated.

== Published cost measurements
The cost of post-quantum signatures on constrained hardware is likewise partly known. Algorithm-level benchmarks for #gls("ml-dsa", first: false) exist for the Cortex-M0+ class @mldsa-cortexm0-bench, a short paper reports secure boot measurements showing that software-only ML-DSA-87 verification is an order of magnitude slower than hardware-accelerated ECDSA @ricardini-pq-secure-boot, and the effect of post-quantum signatures on #gls("suit", first: true) based updates for constrained devices was examined on a different operating system and update stack as early as 2021 @banegas-pq-suit.

== Resulting gap
What is missing is a measurement of these costs inside the #gls("mcuboot", first: false) boot path itself, where the immutable footprint of the verification code, the RAM high-water mark of the real image validation routine and the resulting update path are coupled, and an architecture that keeps the verification root migratable after deployment.

#text(fill: rgb("#cc0000"), size: 24pt)[ToDo!!]