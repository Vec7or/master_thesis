#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl
#let glossary-entry-list = (
  (
    key: "poc",
    short: "POC",
    long: "Proof of Concept",
    description: "A demonstration that a concept or idea is feasible.",
  ),
  (
    key: "feature-freeze",
    short: "Feature Freeze",
    long: "Feature Freeze",
    description: "A point in the project timeline where no new features will be added, and the focus shifts to stabilization and bug fixing.",
  ),
  (
    key: "end-of-elaboration-checklist",
    short: "End of Elaboration Checklist",
    long: "End of Elaboration Checklist",
    description: [
      A list of points that need to be addressed and completed before reaching the #gls("end-of-elaboration", first: false) milestone. The points are as follows:
      - Understood the needs of the stakeholders. Requirements as complete as possible and the scope of the project is at least loosely defined.
      - All tools are understood and set up (IDE, versioning, build system, CI/CD, etc.)
      - The architecture is defined and documented (components, interfaces, data flow, etc.)
      - All big risks as well as questions are addressed and mitigated.
    ],
  ),
  (
    key: "rup",
    short: "RUP",
    long: "Rational Unified Process",
    description: "An iterative software development process framework.",
  ),
  (
    key: "end-of-elaboration",
    short: "End of Elaboration",
    long: "End of Elaboration",
    description: [
      Milestone in the #gls("rup", first: false) methodology at which the greatest risks must be eliminated. At this milestone, a decision is made as to whether the project can continue or not.
    ],
  ),
  (
    key: "scrum+",
    short: "Scrum+",
    long: "Scrum+ Methodology",
    description: [
      Project methodology combining Scrum with the #gls("end-of-elaboration", first: false) phase of #gls("rup", first: false).
    ],
  ),
  (
    key: "clockify",
    short: "Clockify",
    long: "Clockify",
    description: [Tool for time tracking and reporting. Available at https://clockify.me],
  ),
  (
    key: "github",
    short: "GitHub",
    long: "GitHub",
    description: [Web-based platform for version control and collaboration. Available at https://github.com],
  ),
  (
    key: "github-actions",
    short: "GitHub Actions",
    long: "GitHub Actions",
    description: "CI/CD platform integrated with GitHub for automating workflows.",
  ),
  (
    key: "typst",
    short: "Typst",
    long: "Typst",
    description: [A modern markup-based typesetting system. Available at https://typst.app],
  ),
  (
    key: "copilot",
    short: "Copilot",
    long: "Copilot",
    description: "LLM by microsoft available in different versions like Github Copilot or M365 Copilot.",
  ),
  (
    key: "tbd-workflow",
    short: "TBD-Workflow",
    long: "Trunk-Based Development Workflow",
    description: [A branching model that emphasizes continuous integration and short-lived branches. Available at https://trunkbaseddevelopment.com/],
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
