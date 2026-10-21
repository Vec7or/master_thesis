# Prior work and novelty assessment

Status as of **2026-10-16**. Prepared for the advisor meeting; not part of the report.

Purpose: establish whether the proposed task (post-quantum signatures in MCUboot,
plus a crypto-agile root of trust) is still open work, and where the defensible
contribution lies. Every claim below was checked against a primary source on the
date given, not from memory.

## 1. Verdict

The task is viable, but the original framing was wrong about which half is the
contribution:

- **The design question (crypto-agility, migration of the verification root after
  deployment) is genuinely open.** No prior art found addresses it.
- **The measurement questions are reproduction-and-extension, not discovery.**
  Algorithm-level and even secure-boot-level post-quantum costs are published.
  They remain worth measuring inside MCUboot, but cannot be claimed as new.
- **Two collisions must be managed, not ignored:** an open upstream LMS pull
  request, and a competing bootloader that already ships the full algorithm set.

Action taken: the task section of the project plan was rewritten to promote the
design question to RQ1 and to position the work explicitly against the prior art
listed here.

## 2. Upstream MCUboot: the premise holds

Checked by cloning `mcu-tools/mcuboot` at commit `bf0267b` (2026-10-14).

| Check | Result |
|---|---|
| Signature types in tree | `RSA`, `ECDSA_P256`, `ED25519`, `NONE` |
| `imgtool` key modules | `ecdsa.py`, `ed25519.py`, `rsa.py`, `x25519.py` |
| Tree-wide grep: `lms`, `ml-dsa`, `dilithium`, `sphincs`, `quantum` | **0 hits** |
| GitHub title search: ML-DSA / mldsa / dilithium / SLH-DSA / sphincs / quantum | `total_count: 0` |

So no released upstream MCUboot can verify a post-quantum signature. The
motivation of the thesis stands, provided the word *upstream* is used.

## 3. The two collisions

### 3.1 An open LMS pull request, by a long-standing contributor

[mcu-tools/mcuboot#2707 "Add LMS signature support"](https://github.com/mcu-tools/mcuboot/pull/2707)
by `d3zd3z` — the same person who opened the
[2021 PQC discussion #1099](https://github.com/mcu-tools/mcuboot/discussions/1099).

- Opened 2026-04-23, **still open**, last updated 2026-06-05 (~4 months stale).
- 22 commits, 40 files, +2157 / -228.
- **Zero review comments.**
- Adds `boot/bootutil/src/image_lms.c`, `scripts/imgtool/keys/lms.py`,
  `docs/lms.md` (303 lines), TLV type `IMAGE_TLV_LMS` (0x26), and a custom PEM
  envelope that carries the stateful key index `q`.
- Signing via `pyhsslms`, verification via the Mbed TLS 4.x `mbedtls_lms_*` API.
- Single parameter set: `LMS_SHA256_M32_H10` + `LMOTS_SHA256_N32_W8`
  (1024 signatures max, 1452-byte signatures).
- **Explicitly simulator-only: "no platform implementations".**
- Its prerequisite (the Mbed TLS 4.x build routing) has already merged — the
  `mbedtls-v4` feature and the `ext/mbedtls-4.1.0` submodule are present in main.

**Interpretation.** This is not a blocker but it changes the LMS story from
"implement" to "finish and land". A stalled, unreviewed, simulator-only PR that
needs real Cortex-M bring-up, a Zephyr platform path and measurements is arguably
a *better* upstreaming prospect than a greenfield patch, because it already has a
champion inside the project.

**Question for the advisor:** is coordinating directly with the PR author
acceptable, or should the work stay independent for assessment reasons?

### 3.2 wolfBoot already ships the full algorithm set

Per [wolfBoot `docs/PQ.md`](https://github.com/wolfSSL/wolfBoot/blob/master/docs/PQ.md):

- ML-DSA-44 / 65 / 87, LMS/HSS (configurable levels, height, Winternitz),
  XMSS/XMSS^MT (SP 800-208 SHA256 parameter sets).
- A **hybrid mode** where "both classic and PQ signatures are verified,
  sequentially" (`SECONDARY_SIGN`). The docs do not spell out the acceptance
  logic for the case where one of the two fails.
- Published figures: [ML-DSA-87 verified boot in 5.25 ms on an NXP i.MX95
  Cortex-M7 at 800 MHz, 4,201,179 vs 1,741,288 cycles against ECDSA P-256
  (2.4x)](https://www.wolfssl.com/post-quantum-secure-boot-on-the-nxp-i-mx95-cortex-m7/).

**Interpretation.** This is the strongest competitor to the design question, and
also where the gap becomes precise: hybrid signing **fixes both algorithms at
manufacturing time**. It protects a device only if the right pair was chosen
before shipping, and it does not let a deployed device migrate its verification
root afterwards. That distinction — hybrid-at-manufacture versus
migration-after-deployment — is the contribution and is now stated as such in RQ1.

### 3.3 Also relevant, lower severity

- **Renesas RA vendor port.** [FSP 6.6.0](https://renesas.github.io/fsp/group___r_m___m_c_u_b_o_o_t___p_o_r_t.html)
  documents its MCUboot port verifying **ML-DSA-44, ML-DSA-65, ML-DSA-87** over
  Mbed TLS, with optional PQC hardware. Vendor-locked and not upstream, but it
  disproves any claim that "MCUboot cannot do ML-DSA" stated without
  qualification.
- **keelsign.** [smhasan94/keelsign](https://github.com/smhasan94/keelsign) —
  ML-DSA + LMS/HSS, optional hybrid with Ed25519, `no_std` heap-free Rust
  verifier, MCUboot image-check hook, Zephyr module, nRF52840 sample.
  Created 2026-09-28, pushed 2026-10-06, **0 stars, 0 forks**, Apache-2.0, solo
  author, PR titles look machine-generated (`SHA-44`, `SHA-318`). Not a
  credibility threat, but it overlaps two deliverables almost exactly and shows
  the idea is in the air. Should be cited and differentiated.

## 4. Published measurements that overlap the measurement questions

| Source | Platform | Overlap |
|---|---|---|
| [Chhetri, Dhakal, Gautam, arXiv:2603.19340v6](https://arxiv.org/abs/2603.19340) — *Benchmarking NIST-Standardised ML-KEM and ML-DSA on ARM Cortex-M0+: Latency, Rejection-Sampling Variance, and Memory on the RP2040* (2026-08-11) | Cortex-M0+ / RP2040 | Latency + memory for all ML-DSA parameter sets. **Does not cover energy** |
| [Ricardini, *Short Paper: Toward Practical Post-Quantum Secure Boot*, ACM CCS QRCS workshop](https://dl.acm.org/doi/10.1145/3733820.3767142) (2025-10-13) | constrained, HW-accelerated | Secure boot specifically: software ML-DSA-87 34 ms vs 3 ms HW ECDSA; concludes HW acceleration is mandatory |
| [Banegas, Zandberg, Herrmann, Baccelli, Smith, arXiv:2106.05577](https://arxiv.org/abs/2106.05577) (2021) | Cortex-M, RISC-V, ESP32 (RIOT) | **SUIT manifests + LMS / Falcon / Dilithium.** Closest prior art to the update-path question, five years old |
| [Kushwaha, Kaur, eprint 2026/2149](https://eprint.iacr.org/2026/2149) (2026-09-22) | Raspberry Pi 4B, Intel i5 | Automotive secure boot / OTA / V2X guidance, but no Cortex-M and no bootloader integration — weak overlap |

**Interpretation.** The primitive costs are known. What is not published is the
cost *inside the MCUboot verification path*, where immutable footprint, the RAM
high-water mark of the real `image_validate` routine and the resulting update
path are coupled. **Energy on Cortex-M is also still thin** — the RP2040 paper
measures latency, rejection-sampling variance and memory, not energy. The
measurement questions were reframed accordingly: reproduce where platforms
overlap, contribute the integrated-bootloader cost.

## 5. Implementation feasibility risk

The crypto backend does not yet provide what the measurement question names.
From the [TF-PSA-Crypto](https://github.com/Mbed-TLS/TF-PSA-Crypto) ML-DSA
changelog at `103c97f` (2026-10-15):

> "A limited subset of ML-DSA is available from the driver dispatch layer: key
> generation, export public key, one-shot sign and verify, multipart sign and
> verify. **Only pureML-DSA-87 is supported for now.** This interface is
> experimental and may change without notice. ML-DSA is not yet exposed to
> applications."

| Algorithm | Backend situation | Consequence |
|---|---|---|
| ML-DSA-44 | **Not available via PSA** (only ML-DSA-87, experimental, not exposed) | Drive `mldsa-native` directly, or use wolfCrypt / pqm4. Real work item |
| LMS | Mbed TLS 4.1: SHA256 w8 h10 only | Measurement locked to one parameter set unless `hash-sigs` is used |
| SLH-DSA | **No Mbed TLS backend at all** | Needs SPHINCS+ reference or pqm4; worst fit for a bootloader (large signatures, slow verify) |

**Recommendation:** make ML-DSA-44 the headline implementation (zero upstream
work exists), treat LMS as "finish #2707 on hardware", and demote SLH-DSA to a
stretch goal rather than a third pillar.

## 6. Freedom to operate

[US 11,405,213 — *Low latency post-quantum signature verification for fast
secure-boot*](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/11405213).
Worth a footnote if the agility design is to be upstreamed. Not assessed in
detail; legal review is out of scope for this project.

## 7. Open-access substitutes for paywalled standards

The 20-year service-life claim was originally attributed to **ANSI/ISA-62443-2-1 (2024)**, which is
paywalled. Secondary reporting indicates that standard states the lifespan of an IACS "can exceed
twenty years" with legacy hardware and software no longer supported — but that text could not be
verified against the standard itself, and the thesis should not cite a document that cannot be read.

Two freely available sources carry the same claim and were verified directly:

**NIST SP 800-82r3, Guide to Operational Technology (OT) Security** (Sept 2023, DOI
10.6028/NIST.SP.800-82r3), section 3.2.4, p. 37 — verified by extracting the published PDF:

> "The lifespan of an OT system can exceed 20 years. As a result, many legacy systems may contain
> hardware and software that are no longer supported by vendors and cannot be patched or updated to
> protect against new vulnerabilities."

Note how close this is to the reported ISA-62443-2-1 wording. It also makes the unpatchability point
directly. A second passage on p. 30 contrasts a typical IT component lifetime of three to five years
with 10 to 15 years "and sometimes longer" for OT.

**RFC 9019, A Firmware Update Architecture for Internet of Things** (IETF, April 2021), section 7 —
the stronger citation, because it is normative-in-spirit, open, and bootloader-specific:

> "Moreover, since signature schemes based on RSA and Elliptic Curve Cryptography (ECC) may become
> vulnerable to quantum-accelerated key extraction in the future, unchangeable bootloader code in ROM
> is recommended to use post-quantum secure signature schemes such as hash-based signatures
> [RFC8778]. A bootloader author must carefully consider the service lifetime of their product and
> the time horizon for quantum-accelerated key extraction."

Two things make this the anchor citation for the whole thesis:

1. It states the thesis premise as a recommendation in an open IETF document, five years ago.
2. It is co-authored by **David Brown (Linaro)** — confirmed via the GitHub API to be `d3zd3z`, the
   author of both the dormant 2021 PQC discussion and the still-unmerged LMS pull request. The person
   who wrote the recommendation is the same person whose implementation of it has been sitting
   unreviewed since June 2026. That is the gap this project addresses, in one sentence.

Both entries are now in `bibliography/bibliography.yml`, and the motivation section cites them in
place of the ISA standard.

## 8. Still unverified

These claims remain in the project plan without a citation and should be sourced before the plan is
finalised:

- the mapping to **IEC 62443-4-2 EDR 3.12 / 3.13 / 3.14** (also paywalled — an open substitute has
  not yet been identified; the ISAGCA free white papers may serve, or the mapping may have to be
  stated as the author's own reading of the requirement numbers);
- NIST **FIPS 204 / 205**, **SP 800-208**, **RFC 8554**, **RFC 9019 / 9124** as algorithm references,
  all named in prose only. All are open access, so this is a mechanical fix.
