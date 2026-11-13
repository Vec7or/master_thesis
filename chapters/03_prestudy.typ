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
The cost of post-quantum signatures on constrained hardware is likewise partly known. Algorithm-level benchmarks for #gls("ml-dsa", first: false) exist for the Cortex-M33 class @riou-mldsa-benchmarking. Additionally a short paper reports secure boot measurements showing that software-only ML-DSA-87 verification is over 10 times slower than hardware-accelerated #gls("ecdsa", first: true) @ricardini-pq-secure-boot, and the effect of post-quantum signatures on #gls("suit", first: true) based updates for constrained devices was examined on a different operating system and update stack as early as 2021 @banegas-pq-suit.

== Resulting gap
What is missing is a measurement of these costs inside the #gls("mcuboot", first: false) boot path itself, where the immutable footprint of the verification code, the RAM high-water mark of the real image validation routine and the resulting update path are coupled, and an architecture that keeps the verification root migratable after deployment.

= Signature Scheme Selection
This part answers the second preparatory question of the chapter: which post-quantum signature schemes the #gls("poc", first: false) should implement and measure. The selection is made against standardised specifications, not against the research literature. The schemes that have been standardizes have been thoroughly tested and are therefore fit to be used in a device with a extended lifetime.

== The #gls("nist", first: true) portfolio
#gls("nist", first: false) is the standards body of the United States and runs the standardisation process that produced the #gls("pqc", first: false) portfolio. Its publications are the de facto reference for cryptographic standardisation, and this work therefore takes them as the authority on which schemes count as standardised. The portfolio has a classical half and a post-quantum half, and the migration this work enables runs between them, so both have to be utilized. FIPS 186-5, the most recent standard of the classical half approves three signature techniques: #gls("rsa", first: true), #gls("ecdsa", first: false) and #gls("eddsa", first: true) @fips-186-5. These are the schemes upstream #gls("mcuboot", first: false) implements today, so this standard defines the baseline against which the cost figures of #gls("rq", first: false) 3 are reported and the verification root the architecture of #gls("rq", first: false) 2 has to be able to migrate away from. The same revision also withdrew the #gls("dsa", first: true) from signature generation while still allowing it to verify signatures produced before the standard went into effect @fips-186-5, which is a precedent for the problem this work addresses. An algorithm was retired while verifiers already in the field still had to accept what it had signed. All three approved techniques rest on the hardness of integer factorisation or of the discrete logarithm, and are therefore broken by #gls("shor", first: true).

On the post-quantum side, four standardisation tracks exist, three of which are relevant here. #gls("ml-dsa", first: false) is specified in FIPS 204 and is the general-purpose recommendation. It is a module-lattice scheme in three parameter sets, stateless, with no constraint on the number of signatures a key may produce @fips-204. #gls("slh-dsa", first: true) is specified in FIPS 205 and is positioned as the conservative alternative, a hash-based construction that is likewise stateless and whose security rests on the properties of its hash function rather than on an algebraic structure @fips-205. #gls("fn-dsa", first: true) is intended to become FIPS 206 and would produce by a wide margin the smallest signatures and public keys of the portfolio, but its specification has not been published. #gls("nist", first: false) reports it as written and awaiting approval @fips-206-status. Without a published specification there is nothing to implement against and no validation vectors to test an implementation with, so #gls("fn-dsa", first: false) is out of scope here and is not carried into the comparison below.

The fourth track is older and narrower. SP 800-208 approves the stateful hash-based schemes #gls("lms", first: false) and #gls("hss", first: false), specified in RFC 8554 @rfc-8554, and #gls("xmss", first: false) and #gls("xmss-mt", first: true), specified in RFC 8391 @rfc-8391, ahead of the FIPS portfolio and with restrictions attached @nist-sp800-208. The reasoning behind that approval is what makes it relevant here. NIST approves these schemes for applications in which the signer is a single, centralised party that produces few signatures over a long period, and in which the verifier cannot be updated once it is deployed, and names firmware and code signing as the motivating case. Both halves of that description apply to a bootloader: the signing party is the release process of the vendor, and the verification code is the part of the device that cannot be replaced, which is the problem stated in #ref(<prestudy>) and the reason this work exists at all.

== Selection criteria
The gap identified above couples the immutable footprint of the verification code to the update path, so the criteria are derived from the verifier rather than from the signer. In decreasing order of weight:

- *Immutable verifier footprint.* The code size the scheme adds to the part of the boot chain that cannot be replaced after deployment. This is the criterion the gap statement above names first, and it is the one a crypto-agile architecture is least able to repair later, because the migration mechanism itself must fit alongside it.
- *Signature and public key size.* The signature is stored next to the image in flash and is read on every boot. The public key, or a hash of it, occupies the immutable root of trust.
- *Verification time.* Named here as a criterion, but deliberately left open: it is the quantity #gls("rq", first: false) 3 measures, and the figures published so far cover #gls("ml-dsa", first: false) only. It is not used to justify the selection below.
- *Maturity of the security assumption.* Whether the scheme reduces to the preimage and collision resistance of a hash function, which has been studied for decades and degrades predictably, or to a structured lattice assumption, where parameter choices remain subject to cryptanalytic progress.
- *Primitive reuse.* Whether the scheme needs a primitive the boot path already contains. SHA-256 is present for image integrity and measured boot regardless of the signature scheme; a number-theoretic transform or a discrete Gaussian sampler is not.
- *Signing-side operational cost.* Whether the scheme requires state to be carried across signing operations, and what happens if that state is mismanaged.
- *Backend reachability.* Whether the scheme is reachable from #gls("mcuboot", first: false) through the crypto backends it builds against, which as shown above is the constraint that has so far limited upstream support @tf-psa-crypto.

== Comparison
#ref(<tab-scheme-comparison>) collects the schemes above with the parameter sets that are plausible for a constrained bootloader. Sizes are given per parameter set and with the claimed security level named, since they are not comparable otherwise. The hash-based schemes of SP 800-208 are not assigned NIST security categories, so their design security level is given instead. The classical rows state classical security only: a level of 128 bit there is not comparable to the same figure for a hash-based scheme, because it does not survive a quantum adversary at all.

#figure(
  text(size: 8.5pt)[
    #set par(justify: false)
    #table(
      columns: (auto, auto, auto, auto, auto, auto),
      inset: 4.5pt,
      align: (left, left, left, left, right, right),
      table.header(
        [*Scheme and parameter set*],
        [*Standard*],
        [*Family*],
        [*Security*],
        [*Public key*],
        [*Signature*],
      ),
      [RSA-2048], [FIPS 186-5], [Finite field], [112 bit, classical], [256 B], [256 B],
      [ECDSA P-256], [FIPS 186-5], [Elliptic curve], [128 bit, classical], [64 B], [64 B],
      [Ed25519], [FIPS 186-5], [Edwards curve], [128 bit, classical], [32 B], [64 B],
      [ML-DSA-44], [FIPS 204], [Module lattice, stateless], [Category 2], [1312 B], [2420 B],
      [ML-DSA-65], [FIPS 204], [Module lattice, stateless], [Category 3], [1952 B], [3309 B],
      [ML-DSA-87], [FIPS 204], [Module lattice, stateless], [Category 5], [2592 B], [4627 B],
      [SLH-DSA-SHA2-128s], [FIPS 205], [Hash-based, stateless], [Category 1], [32 B], [7856 B],
      [SLH-DSA-SHA2-256f], [FIPS 205], [Hash-based, stateless], [Category 5], [64 B], [49856 B],
      [`LMS_SHA256_M32_H10` with `LMOTS_SHA256_N32_W8`], [SP 800-208, RFC 8554], [Hash-based, stateful], [128 bit], [56 B], [1452 B],
      [HSS, two levels, same parameters], [SP 800-208, RFC 8554], [Hash-based, stateful], [128 bit], [60 B], [2964 B],
      [`XMSS-SHA2_10_256`], [SP 800-208, RFC 8391], [Hash-based, stateful], [128 bit], [68 B], [2500 B],
    )
  ],
  caption: [Digital signature schemes approved by NIST, with the parameter sets relevant to a constrained bootloader. Sizes follow the encodings of the respective standards; the classical rows give the raw public key and signature, excluding the RSA public exponent and any DER wrapper.],
) <tab-scheme-comparison>

The two hash-based rows of SP 800-208 are worth deriving, because they show where the cost of the multi-tree construction goes. An #gls("lms", first: false) signature under RFC 8554 is $12 + n(p+1) + m h$ bytes; with $n = m = 32$, $p = 34$ and $h = 10$ this is 1452 bytes, of which 1088 are the Winternitz chain ends and only 320 the authentication path @rfc-8554. Raising the signature capacity by adding a second tree costs one further #gls("lms", first: false) signature and one signed #gls("lms", first: false) public key in every signature produced, so a two-level #gls("hss", first: false) signature is $4 + (1452 + 56) + 1452 = 2964$ bytes and lifts the capacity from $2^10$ to $2^20$ signatures. The verifier correspondingly repeats its work once per level. The trade is therefore capacity against both signature size and verification time, and it is a trade the architecture has to expose rather than fix.

== Selected schemes
The #gls("poc", first: false) implements #gls("lms", first: false)/#gls("hss", first: false) as the primary verification root and ML-DSA-44 as a lattice comparison arm.

#gls("lms", first: false)/#gls("hss", first: false) is selected on four grounds. The first is the immutable verifier footprint. Verification consists of a hash function applied in a chain and a walk up an authentication path; it contains no number-theoretic transform, no rejection sampling, no hint decoding and no modular arithmetic over a ring, so there is correspondingly little code to place in unreplaceable memory and little to review when it is placed there. The second follows from it: the only primitive required is SHA-256, which the boot path already contains for image integrity, so the marginal code cost of the verifier is close to the cost of the Merkle logic alone. The third is the maturity of the assumption. Security reduces to the preimage and collision resistance of the hash function, with no structured algebraic assumption underneath it and no exposure to progress in lattice cryptanalysis; a quantum adversary gains only the quadratic speedup of Grover's algorithm on preimage search, which the parameter sets already account for. The fourth is that the scheme is the one the ecosystem has converged on for this specific application: it is the subject of the single open pull request against upstream #gls("mcuboot", first: false) @mcuboot-lms-pr, it ships in a production competitor @wolfboot-pq-docs, and SP 800-208 approves it with firmware signing as the named motivation @nist-sp800-208.

Three properties argue against it and are accepted deliberately. Statefulness is a catastrophic failure mode rather than a degradation: reusing a one-time key index allows an attacker to combine two signatures into a forgery, so the signer has to guarantee that no index is ever used twice, including across backup restores and parallel signing hosts. The signature capacity is fixed at key generation, which is the main reason #gls("hss", first: false) is in scope at all. And SP 800-208 requires that private keys be non-exportable and that key generation and signing occur inside a cryptographic module, which bears directly on the `imgtool` extension this work delivers, since `imgtool` has no notion of one-time key index state today. These are inputs to #ref(<architecture>) rather than objections to the selection. Notably, verification cost is not among the arguments in favour: at $w = 8$ the Winternitz chains dominate verification, and whether that is cheaper or more expensive than a lattice verification on the target device is precisely the open question #gls("rq", first: false) 3 answers.

ML-DSA-44 is selected as the second arm for three reasons. It is stateless, so it carries none of the signing-side constraints above and shows what the architecture looks like without them. It is the scheme for which published comparison figures exist @riou-mldsa-benchmarking @ricardini-pq-secure-boot, so the measurements of #gls("rq", first: false) 3 can be related to prior numbers. And it belongs to a different family on a different hardness assumption, which is what makes the crypto-agility claim of this work demonstrable: a mechanism that can migrate between a stateful hash-based root and a stateless lattice root has been shown to span the portfolio, whereas one exercised only across parameter sets of a single scheme has not.

The two arms are not integrated to the same depth, which resolves the qualification made in the task. Single-tree #gls("lms", first: false) and ML-DSA-44 are integrated through the backend path and measured; the #gls("hss", first: false) multi-tree case is carried as a smaller #gls("poc", first: false), because #gls("hss", first: false) is not offered by the backend #gls("mcuboot", first: false) builds against @tf-psa-crypto and therefore requires a separate implementation rather than a configuration change.

== Excluded schemes
#gls("slh-dsa", first: false) is excluded despite having the strongest assumption argument in the portfolio, being hash-based and stateless at once. It fails on the two highest-weighted criteria. Its smallest signature is 7856 bytes against 1452 for the selected #gls("lms", first: false) parameter set, and rises to 49856 bytes at the highest security level, which has to be held in flash per image slot and read on every boot; its verification is also substantially heavier, since the hypertree construction that removes the state also multiplies the number of hash invocations. That it has no backend available to #gls("mcuboot", first: false) at all is a secondary and practical point, not the reason for the exclusion.

#gls("xmss", first: false) and #gls("xmss-mt", first: false) are excluded as redundant rather than deficient. They are approved in the same SP 800-208, rest on the same assumption and offer the same footprint advantage, differing from #gls("lms", first: false) in using WOTS+ one-time signatures and bitmasked tree hashing @rfc-8391. Since they share the properties for which #gls("lms", first: false)/#gls("hss", first: false) is selected and share its statefulness, examining both would widen the measurement matrix without testing a different point in the design space, which is instead what the ML-DSA-44 arm provides.

= Crypto-agile boot architecture
That FIPS 206 is written but not approved is itself an argument for the crypto-agile architecture #gls("rq", first: false) 2 asks for. The portfolio a device must verify against is not closed at the time the device is commissioned, and a scheme that is unavailable today may well be the preferred one inside the service life of the hardware. The capacity to adopt a verification root that does not yet exist is therefore a requirement rather than a convenience.

#text(fill: rgb("#cc0000"), size: 24pt)[ToDo!!]
