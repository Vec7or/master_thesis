#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl
#let glossary-entry-list = (
  (
    key: "poc",
    short: "POC",
    long: "Proof of Concept",
    description: "A demonstration that a concept or idea is feasible.",
  ),
  (
    key: "rq",
    short: "RQ",
    plural: "RQs",
    long: "Research Question",
    longplural: "Research Questions",
    description: [A question this work sets out to answer. The three research questions of this project are stated in the task and are referred to as RQ 1, RQ 2 and RQ 3.],
  ),
  (
    key: "feature-freeze",
    short: "Feature Freeze",
    long: "Feature Freeze",
    description: "A point in the project timeline where no new features will be added, and the focus shifts to stabilization and bug fixing.",
  ),
  (
    key: "adr",
    short: "ADR",
    long: "Architecture Decision Record",
    description: [A documentation approach for architectural decisions to make them visible and comprehensible. See: https://adr.github.io/],
  ),
  (
    key: "zephyr-rtos",
    short: "Zephyr RTOS",
    long: "Zephyr Real-Time Operating System",
    description: [An open-source real-time operating system for connected, resource-constrained devices. See: https://zephyrproject.org/],
  ),
  (
    key: "mcuboot",
    short: "MCUboot",
    long: "MCUboot",
    description: [A secure bootloader for 32-bit microcontrollers that provides image verification and software upgrade. It is not tied to a specific operating system or hardware and relies on porting layers from the operating system it is used with; #gls("zephyr-rtos", first: false), Apache Mynewt, Apache NuttX, RIOT and Mbed OS are supported. See: https://docs.mcuboot.com/],
  ),
  (
    key: "ot",
    short: "OT",
    long: "Operational Technology",
    description: [Hardware and software that detects or causes a change in physical processes through direct monitoring or control of physical devices, as found in industrial plants and critical infrastructure. See: NIST SP 800-82r3],
  ),
  (
    key: "ram",
    short: "RAM",
    long: "Random-Access Memory",
    description: [Volatile working memory. For signature verification the relevant figure is the high-water mark of stack and heap reached during the operation.],
  ),
  (
    key: "ncsc",
    short: "NCSC",
    long: "National Cyber Security Centre",
    description: [The national cyber security authority of the United Kingdom, which among other things publishes the migration timeline for post-quantum cryptography referenced in this work. See: https://www.ncsc.gov.uk/],
  ),
  (
    key: "pqc",
    short: "PQC",
    long: "Post-Quantum Cryptography",
    description: [Cryptographic algorithms that are designed to remain secure against an attacker in possession of a cryptographically relevant quantum computer.],
  ),
  (
    key: "ml-dsa",
    short: "ML-DSA",
    long: "Module-Lattice-Based Digital Signature Algorithm",
    description: [Lattice-based #gls("pqc", first: false) signature scheme standardized in NIST FIPS 204, derived from CRYSTALS-Dilithium.],
  ),
  (
    key: "slh-dsa",
    short: "SLH-DSA",
    long: "Stateless Hash-Based Digital Signature Algorithm",
    description: [Stateless hash-based #gls("pqc", first: false) signature scheme standardized in NIST FIPS 205, derived from SPHINCS+.],
  ),
  (
    key: "lms",
    short: "LMS",
    long: "Leighton-Micali Signature",
    description: [Stateful hash-based signature scheme specified in RFC 8554 and approved in NIST SP 800-208, often used for firmware signing.],
  ),
  (
    key: "suit",
    short: "SUIT",
    long: "Software Updates for Internet of Things",
    description: [IETF manifest format and architecture for firmware updates of constrained devices, specified in RFC 9019 and RFC 9124 and following documents.],
  ),
  // Add more terms
)
