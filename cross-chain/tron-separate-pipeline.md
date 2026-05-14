# TRON Required a Separate Pipeline

One of the early architectural complications came from supporting both EVM and non-EVM ecosystems.

TRON was included in the global MOLEPIN allocation model, but its deployment pipeline differed significantly from EVM-based chains.

This created several operational considerations:

- separate deployment tooling
- separate accounting logic
- separate mint procedures
- independent bridge assumptions

As a result:

- EVM allocations were managed directly inside the Hardhat deployment system
- TRON allocations were intentionally separated into an independent pipeline

This separation reduced the risk of accidental cross-environment mint inconsistencies.
