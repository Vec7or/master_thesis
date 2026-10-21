#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl

#text(fill: rgb("#cc0000"), size: 24pt)[ToDo!!]

=== Limitations
- True immutability is not reproduced on development hardware. Mask ROM or one-time-programmable storage is emulated by write-protected flash regions or lock bits, which approximates the constraint but does not reproduce it.
- The scope is the boot and firmware update trust chain. Transport security, provisioning and key management infrastructure as well as remote attestation and firmware image encryption are not covered. Only signature schemes are examined.
- No side-channel or fault-injection evaluation and no formal verification or security audit of the verification code are performed.
- Depending on backend availability, some schemes are integrated at prototype level rather than in production quality. Which ones is a result of the prestudy.
- The integration follows the contribution guidelines of the #gls("mcuboot", first: false) project. Whether it is submitted is decided at the end of the project and acceptance is up to the upstream maintainers. Neither is a criterion for success.
- Neither fleet-scale rollout nor the 20-year service life can be tested within the project. Migration is demonstrated on a small number of devices and long-term behaviour is argued from the architecture.
- Measurements depend on toolchain, optimisation settings, board and clock configuration. They are comparable within this work rather than absolute.